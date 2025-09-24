SELECTION="$(echo -e "⏼  Reboot \n⏻  Shutdown \n⭘  Lock (TODO) \n⭘  Suspend (TODO) \n⭘  Logout (TODO)" | fuzzel -d --index)"

case $SELECTION in
	0) sudo reboot ;;
	1) sudo shutdown ;;
  2) echo $SELECTION ;;
  3) echo $SELECTION ;;
  4) echo $SELECTION ;;
esac
