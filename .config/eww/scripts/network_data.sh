connected=$(nc -z -w 5 google.com 443 && echo y || echo n)
ethernet=$(nmcli -t -f TYPE connection show --active | grep -q "ethernet" && echo y || echo n)
netName=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes" {print $2}')
interface=$(ip route get 1.1.1.1 | awk '{print $5}')
ipv4=$(ip route get 1.1.1.1 | awk '{print $7}')
echo "{\"connected\":\"${connected}\",\"ethernet\":\"${ethernet}\",\"netName\":\"${netName}\",\"interface\":\"${interface}\",\"ipv4\":\"${ipv4}\"}"