# Manual colouring helpers.
color_id() {
  case $1 in
    black)   echo '0' ;;
    red)     echo '1' ;;
    green)   echo '2' ;;
    yellow)  echo '3' ;;
    blue)    echo '4' ;;
    magenta) echo '5' ;;
    cyan)    echo '6' ;;
    gray)    echo '7' ;;
    *)       echo "$1" ;;
  esac
}

color() {
  if [[ -z $1 || $1 == 'reset' ]]; then
    echo "\e[0m"
  elif [[ $1 == 'bright' ]]; then
    echo "\e[3$(color_id "$2");1m"
  else
    echo "\e[3$(color_id "$1")m"
  fi
}
