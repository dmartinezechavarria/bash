##
# @internal
#
# @description Dibuja a Wall-e
#
# @example
#   printwalle
#
printwalle (){
  white=$_COLORWHITE_
  light_blue=$_COLORLIGHTBLUE_
  gray=$_COLORLIGHTGRAY_
  light_gray=$_COLORLIGHTGRAY_
  dark_gray=$_COLORDARKGRAY_
  bronze=$_COLORLIGHTYELLOW_
  yellow=$_COLORYELLOW_
  lime=$_COLORLIGHTGREEN_
  brown=$_COLORRED_


  # Line 1
  # printf --background white
  printf $light_gray
  printf '\n'
  printf '  __'
  printf $gray
  printf '      _____ ____\n'
  # Line 2
  printf $light_gray
  printf ' /---__  '
  printf $gray
  printf '('
  printf $white
  printf ' (O)'
  printf $gray
  printf '|/'
  printf $white
  printf '(O) '
  printf $gray
  printf ')\n'
  # Line 3
  printf $light_gray
  printf '  \\ \b\\ \b\\ \b\\/'
  printf $gray
  printf '  \\ \b___'
  printf '/'
  printf $bronze
  printf 'U'
  printf $gray
  printf '\\___/\n'
  # Line 4
  printf $light_gray
  printf '    L\\       '
  printf $bronze
  printf '||\n'
  # Line 5
  printf $gray
  printf '     \\ \b\\ '
  printf $gray
  printf '____'
  printf $bronze
  printf '|||'
  printf $gray
  printf '_____\n'
  # Line 6
  printf '      \\ \b\\ \b|'
  printf '=='
  printf $bronze
  printf '|'
  printf $lime
  printf '[]'
  printf $gray
  printf '__'
  printf $light_gray
  printf '/==|\\ \b'
  printf $gray
  printf -- '-|\n'
  #Line 7
  printf '       \\ \b'
  printf $yellow
  printf '|* '
  printf $bronze
  printf '|'
  printf $yellow
  printf '|'
  printf $bronze
  printf '|'
  printf $yellow
  printf '||'
  printf $light_gray
  printf '\\==|/'
  printf $gray
  printf -- '-|\n'
  # Line 8
  printf $dark_gray
  printf '    ____'
  printf $yellow
  printf '| *|[]['
  printf $bronze
  printf ']'
  printf $yellow
  printf -- '-- |'
  printf $dark_gray
  printf '_\n'
  # Line 9
  printf '   ||EEE|'
  printf $yellow
  printf '__E'
  printf $white
  printf 'E'
  printf $yellow
  printf 'E'
  printf $white
  printf 'E'
  printf $yellow
  printf '_['
  printf $bronze
  printf ']_|'
  printf $dark_gray
  printf 'EE\\ \b\n'
  # Line 10
  printf '   ||EEE|'
  printf $gray
  printf '=O     O'
  printf $dark_gray
  printf '|'
  printf $gray
  printf '='
  printf $dark_gray
  printf '|EEE|\n'
  # Line 11
  printf '   \\ \bLEEE|         \\ \b|EEE|  '
  printf $brown
  printf '__))\n'
  # Line 12
  printf '                          ```\n'

  printf $_FONTDEFAULT_
  printf $_COLORDEFAULT_
  printf $_BACKGROUNDDEFAULT_
}