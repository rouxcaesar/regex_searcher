# Assumption: both arguments will be strings

def regex_searcher(pattern, string)
	is_match_helper(pattern, string, 0, 0)
end

def is_match_helper(pattern, string, pattern_idx, string_idx)
	# Base case of reaching the end of both the pattern and string without any false returns
	if (string_idx >= string.length)

		if (pattern_idx >= pattern.length)
			return true
		else
			if (pattern_idx < pattern.length) && (pattern[pattern_idx - 1] == '*' || pattern[pattern_idx - 1] == '+')
				return is_match_helper(pattern, string, pattern_idx + 1, string_idx)
			elsif (pattern_idx < pattern.length) && (pattern[pattern_idx] == '?' || pattern[pattern_idx - 1] == '?')
				return is_match_helper(pattern, string, pattern_idx + 1, string_idx)
			else
				return false
			end
		end

	# If we've reached the end of our pattern but not our string, then we do not have a match and return false
	elsif (pattern_idx >= pattern.length) && (string_idx < string.length)
		return false

	# If we haven't reached the end of our pattern or string, and the current pattern char is '*', then we recurse
	elsif (pattern[pattern_idx] == '*')
		return is_match_helper(pattern, string, pattern_idx + 1, string_idx)
	elsif (pattern[pattern_idx - 1] == '*')
		if pattern_char_exact_match?(pattern[pattern_idx], string[string_idx])
			return is_match_helper(pattern, string, pattern_idx, string_idx + 1)
		else
			return is_match_helper(pattern, string, pattern_idx + 1, string_idx)
		end

	# Logic for '+'

	elsif (pattern[pattern_idx] == '+')
		if (pattern[pattern_idx + 1] == '.' || pattern[pattern_idx + 1] == string[string_idx])
			return is_match_helper(pattern, string, pattern_idx + 1, string_idx)
		else
			return false
		end
	elsif (pattern[pattern_idx - 1] == '+')
		if pattern_char_exact_match?(pattern[pattern_idx], string[string_idx])
			return is_match_helper(pattern, string, pattern_idx, string_idx + 1)
		else
			return is_match_helper(pattern, string, pattern_idx + 1, string_idx)
		end

	# Logic for '?'

	elsif (pattern[pattern_idx] == '?')
		return (is_match_helper(pattern, string, pattern_idx + 1, string_idx) || is_match_helper(pattern, string, pattern_idx + 2, string_idx))
	elsif (pattern[pattern_idx - 1] == '?')
		if pattern_char_exact_match?(pattern[pattern_idx], string[string_idx])
			return is_match_helper(pattern, string, pattern_idx + 1, string_idx + 1)
		else
			return is_match_helper(pattern, string, pattern_idx + 1, string_idx)
		end

	# Base case where the current char in pattern is '.' or the same as the current char in string. If true, recurse.
	elsif pattern_char_exact_match?(pattern[pattern_idx], string[string_idx])
		return is_match_helper(pattern, string, pattern_idx + 1, string_idx + 1)
	else
		return false
	end
end

def pattern_char_exact_match?(pattern_char, string_char)
	pattern_char == '.' || (pattern_char == string_char)
end



################################################
# Test Cases
################################################

# exact match 
puts "Tests for exact matches"
puts regex_searcher('abc', 'abc') == true
# simple mismatch
puts regex_searcher('abd', 'abc') == false

# any-char matches
puts "", "Tests for any-char matches"
puts regex_searcher('a.c', 'a.c') == true
puts regex_searcher('a.c', 'abc') == true

# optional pattern char '*' matches with and without
puts "", "Tests for optional pattern char '*' matches with and without"
puts regex_searcher('a*b', 'abbb') == true
puts regex_searcher('a*bc', 'ac') == true

# non-optional pattern char '+' matches 
puts "", "Tests for non-optional pattern char '+' matches"
puts regex_searcher('a+b', 'abbb') == true
puts regex_searcher('a+bc', 'abc') == true
puts regex_searcher('a+bc', 'ac') == false

# optional pattern char '?' matches with and without
puts "", "Tests for optional pattern char '?' matches with and without"
puts regex_searcher('a?bc', 'abc') == true
puts regex_searcher('a?bc', 'ac') == true
puts regex_searcher('a?b', 'a') == true

# an optional char that can match but is not forced to
puts "", "Tests for optional pattern char '?' that can match but is not forced to"
puts regex_searcher('?aab', 'ab') == true

# classic log searching
puts "", "Tests for classic log searching"
puts regex_searcher('ERROR: *.', 'ERROR: file not found') == true
puts regex_searcher('ERROR: *.', 'WARNING: file not found') == false



