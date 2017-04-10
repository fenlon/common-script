TJ_HOST_HOME=/Users/fenlon/.tj_host

function pwdx {
  lsof -a -p $1 -d cwd -n | tail -1 | awk '{print $NF}'
}

function netstat_ {
  lsof -nP -iTCP:$1 -sTCP:LISTEN|sed -n "2,1p"|awk '{print $2}'
}

function tj {
  cat $TJ_HOST_HOME 
}

function to {
  if [ $# != 1 ];then
      echo "Usage: to [hostId]"
      return
  fi
  
  hostId=$1
  
  OLD_IFS=$IFS
  IFS='
  '
  not_found="ip not found"
  remoteIp=$not_found
  for line in  $(cat $TJ_HOST_HOME) 
  do
      if [ ${#line} != 0 -a ${line:0:1} != "[" -a ${line: -1} != "]" ];then
         
         host_id="$(echo "$line"|awk -F '\t' '{print $1}')"
         ip="$(echo "$line"|awk -F '\t' '{print $2}')"
         if [ "$host_id" = "$hostId" ];then
            remoteIp=$ip
            break
         fi
      fi
  done  
  
  IFS=$OLD_IFS
  
  if [ $remoteIp = $not_found ];then
     echo $not_found
     return
  fi
  echo "final goto $remoteIp"
  ssh work@$remoteIp
}
