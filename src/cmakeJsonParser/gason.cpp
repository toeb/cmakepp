#include "gason.h"
#include <ctype.h>
#include <stdlib.h>

#define JSON_ZONE_SIZE 4096
#define JSON_STACK_SIZE 32

JsonAllocator::~JsonAllocator() {
	deallocate();
}

void *JsonAllocator::allocate(size_t size) {
	size = (size + 7) & ~7;

	if (head) {
		if (head->used + size <= JSON_ZONE_SIZE) {
			char *p = (char *)head + head->used;
			head->used += size;
			return p;
		}
	}

	size_t allocSize = sizeof(Zone) + size;
	Zone *zone = (Zone *)malloc(allocSize <= JSON_ZONE_SIZE ? JSON_ZONE_SIZE : allocSize);
	zone->used = allocSize;
	if (allocSize <= JSON_ZONE_SIZE || head == nullptr) {
		zone->next = head;
		head = zone;
	} else {
		zone->next = head->next;
		head->next = zone;
	}
	return (char *)zone + sizeof(Zone);
}

void JsonAllocator::deallocate() {
	while (head) {
		Zone *next = head->next;
		free(head);
		head = next;
	}
}

static inline bool isdelim(char c) {
	return isspace(c) || c == ',' || c == ':' || c == ']' || c == '}' || c == '\0';
}

static inline int char2int(char c) {
	if (c >= 'a')
		return c - 'a' + 10;
	if (c >= 'A')
		return c - 'A' + 10;
	return c - '0';
}

static double string2double(char *s, char **endptr) {
	char ch = *s;
	if (ch == '+' || ch == '-')
		++s;

	double result = 0;
	while (isdigit(*s))
		result = (result * 10) + (*s++ - '0');

	if (*s == '.') {
		++s;

		double fraction = 1;
		while (isdigit(*s)) {
			fraction *= 0.1;
			result += (*s++ - '0') * fraction;
		}
	}

	if (*s == 'e' || *s == 'E') {
		++s;

		double base = 10;
		if (*s == '+')
			++s;
		else if (*s == '-') {
			++s;
			base = 0.1;
		}

		int exponent = 0;
		while (isdigit(*s))
			exponent = (exponent * 10) + (*s++ - '0');

		double power = 1;
		for (; exponent; exponent >>= 1, base *= base)
			if (exponent & 1)
				power *= base;

		result *= power;
	}

	*endptr = s;
	return ch == '-' ? -result : result;
}

static inline JsonNode *insertAfter(JsonNode *tail, JsonNode *node) {
	if (!tail)
		return node->next = node;
	node->next = tail->next;
	tail->next = node;
	return node;
}

static inline JsonValue listToValue(JsonTag tag, JsonNode *tail) {
	if (tail) {
		auto head = tail->next;
		tail->next = nullptr;
		return JsonValue(tag, head);
	}
	return JsonValue(tag, nullptr);
}

JsonParseStatus jsonParse(char *s, char **endptr, JsonValue *value, JsonAllocator &allocator) {
	JsonNode *tails[JSON_STACK_SIZE];
	JsonTag tags[JSON_STACK_SIZE];
	char *keys[JSON_STACK_SIZE];
	int pos = -1;

	bool separator = true;

	*endptr = s;
	
	while (*s) {
		JsonValue o;

		while (*s && isspace(*s))
			++s;

		*endptr = s++;
		switch (**endptr) {
		case '\0':
			continue;
		case '-':
			if (!isdigit(*s) && *s != '.') {
				*endptr = s;
				return JSON_PARSE_BAD_NUMBER;
			}
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			o = JsonValue(string2double(*endptr, &s));
			if (!isdelim(*s)) {
				*endptr = s;
				return JSON_PARSE_BAD_NUMBER;
			}
			break;
		case '"':
			o = JsonValue(JSON_TAG_STRING, s);
			for (char *it = s; *s; ++it, ++s) {
				int c = *it = *s;
				if (c == '\\') {
					c = *++s;
					switch (c) {
					case '\\':
					case '"':
					case '/':
						*it = c;
						break;
					case 'b':
						*it = '\b';
						break;
					case 'f':
						*it = '\f';
						break;
					case 'n':
						*it = '\n';
						break;
					case 'r':
						*it = '\r';
						break;
					case 't':
						*it = '\t';
						break;
					case 'u':
						c = 0;
						for (int i = 0; i < 4; ++i) {
							if (!isxdigit(*++s)) {
								*endptr = s;
								return JSON_PARSE_BAD_STRING;
							}
							c = c * 16 + char2int(*s);
						}
						if (c < 0x80) {
							*it = c;
						} else if (c < 0x800) {
							*it++ = 0xC0 | (c >> 6);
							*it = 0x80 | (c & 0x3F);
						} else {
							*it++ = 0xE0 | (c >> 12);
							*it++ = 0x80 | ((c >> 6) & 0x3F);
							*it = 0x80 | (c & 0x3F);
						}
						break;
					default:
						*endptr = s;
						return JSON_PARSE_BAD_STRING;
					}
				} else if (iscntrl(c)) {
					*endptr = s;
					return JSON_PARSE_BAD_STRING;
				} else if (c == '"') {
					*it = 0;
					++s;
					break;
				}
			}
			if (!isdelim(*s)) {
				*endptr = s;
				return JSON_PARSE_BAD_STRING;
			}
			break;
		case 't':
			for (const char *it = "rue"; *it; ++it, ++s) {
				if (*it != *s)
					return JSON_PARSE_BAD_IDENTIFIER;
			}
			if (!isdelim(*s))
				return JSON_PARSE_BAD_IDENTIFIER;
			o = JsonValue(JSON_TAG_BOOL, (void *)true);
			break;
		case 'f':
			for (const char *it = "alse"; *it; ++it, ++s) {
				if (*it != *s)
					return JSON_PARSE_BAD_IDENTIFIER;
			}
			if (!isdelim(*s))
				return JSON_PARSE_BAD_IDENTIFIER;
			o = JsonValue(JSON_TAG_BOOL, (void *)false);
			break;
		case 'n':
			for (const char *it = "ull"; *it; ++it, ++s) {
				if (*it != *s)
					return JSON_PARSE_BAD_IDENTIFIER;
			}
			if (!isdelim(*s))
				return JSON_PARSE_BAD_IDENTIFIER;
			break;
		case ']':
			if (pos == -1)
				return JSON_PARSE_STACK_UNDERFLOW;
			if (tags[pos] != JSON_TAG_ARRAY)
				return JSON_PARSE_MISMATCH_BRACKET;
			o = listToValue(JSON_TAG_ARRAY, tails[pos--]);
			break;
		case '}':
			if (pos == -1)
				return JSON_PARSE_STACK_UNDERFLOW;
			if (tags[pos] != JSON_TAG_OBJECT)
				return JSON_PARSE_MISMATCH_BRACKET;
			if (keys[pos] != nullptr)
				return JSON_PARSE_UNEXPECTED_CHARACTER;
			o = listToValue(JSON_TAG_OBJECT, tails[pos--]);
			break;
		case '[':
			if (++pos == JSON_STACK_SIZE)
				return JSON_PARSE_STACK_OVERFLOW;
			tails[pos] = nullptr;
			tags[pos] = JSON_TAG_ARRAY;
			keys[pos] = nullptr;
			separator = true;
			continue;
		case '{':
			if (++pos == JSON_STACK_SIZE)
				return JSON_PARSE_STACK_OVERFLOW;
			tails[pos] = nullptr;
			tags[pos] = JSON_TAG_OBJECT;
			keys[pos] = nullptr;
			separator = true;
			continue;
		case ':':
			if (separator || keys[pos] == nullptr)
				return JSON_PARSE_UNEXPECTED_CHARACTER;
			separator = true;
			continue;
		case ',':
			if (separator || keys[pos] != nullptr)
				return JSON_PARSE_UNEXPECTED_CHARACTER;
			separator = true;
			continue;
		default:
			return JSON_PARSE_UNEXPECTED_CHARACTER;
		}

		separator = false;

		if (pos == -1) {
			*endptr = s;
			*value = o;
			return JSON_PARSE_OK;
		}

		if (tags[pos] == JSON_TAG_OBJECT) {
			if (!keys[pos]) {
				if (o.getTag() != JSON_TAG_STRING)
					return JSON_PARSE_UNQUOTED_KEY;
				keys[pos] = o.toString();
				continue;
			}
			tails[pos] = insertAfter(tails[pos], (JsonNode *)allocator.allocate(sizeof(JsonNode)));
			tails[pos]->key = keys[pos];
			keys[pos] = nullptr;
		} else {
			tails[pos] = insertAfter(tails[pos], (JsonNode *)allocator.allocate(sizeof(JsonNode) - sizeof(char *)));
		}
		tails[pos]->value = o;
	}
	return JSON_PARSE_BREAKING_BAD;
}
