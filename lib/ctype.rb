#
# = ctype.rb: ctype.h as syntactic sugar for Ruby
#
# Homepage::  https://www.github.com/Koumarin/ctype.git
# Authors::   murphy (Kornelius Kalnbach),
#             Koumarin (Alice Figueiredo)
# Copyright:: (cc) 2005 cYcnus
# License::   GPL
# Version:: 0.3.0 (2023-07-01)
#
# === It's simple
#
# C:    <code>isalpha(x)</code>
# Ruby: <code>x.alpha?</code>
#
# Also working (as of version 0.2.0):
#
# nil.digit? == false  (useful if getc returns nil)
# 'a string'.alpha? == true
#
# === Further information
# 
# Uses the POSIX character classes [[:...:]] implemented in Regexp.
#
# See the documentation for ctype.h at
# http://www-ccs.ucsd.edu/c/ctype.html
#

=begin

POSIX Character Classes. [:class:]
This is an alternate method of specifying a range of characters to match.

[:alnum:]  matches alphanumeric characters. This is equivalent to A-Za-z0-9.
[:alpha:]  matches alphabetic characters. This is equivalent to A-Za-z.
[:blank:]  matches a space or a tab.
[:cntrl:]  matches control characters.
[:digit:]  matches (decimal) digits. This is equivalent to 0-9.
[:graph:]  matches graphic printable characters. Matches characters in the
         range of ASCII 33 - 126. This is the same as [:print:], below, but
         excluding the space character.
[:lower:]  matches lowercase alphabetic characters. This is equivalent to a-z.
[:print:]  matches printable characters. Matches characters in the range
         of ASCII 32 - 126. This is the same as [:graph:], above, but adding
         the space character.
[:space:]  matches whitespace characters (space and horizontal tab).
[:upper:]  matches uppercase alphabetic characters. This is equivalent to A-Z.
[:xdigit:] matches hexadecimal digits. This is equivalent to 0-9A-Fa-f.

=end

POSIX_CHARACTER_CLASSES = %w[ alnum alpha cntrl digit graph lower print punct space upper xdigit ]

# ?A.upper?
class Fixnum
  POSIX_CHARACTER_CLASSES.each do |c|
    rx = Regexp.new('[[:' + c + ':]]')

    define_method (c + '?').to_sym do
      self >= 0 and rx =~ self.chr
    end
  end
end

# 'A'.upper?
class String
  POSIX_CHARACTER_CLASSES.each do |c|
    m = (c + '?').to_sym

    define_method m do
      codepoints.each do |n|
	return false unless n.send m
      end

      true
    end
  end
end

# nil.upper?
class NilClass
  POSIX_CHARACTER_CLASSES.each do |c|
    define_method (c + '?').to_sym do
      false
    end
  end
end
