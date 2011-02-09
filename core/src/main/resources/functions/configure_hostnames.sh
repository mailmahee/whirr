function configure_hostnames() {
  local OPTIND
  local OPTARG
  
  CLOUD_PROVIDER=
  while getopts "c:" OPTION; do
    case $OPTION in
    c)
      CLOUD_PROVIDER="$OPTARG"
      shift $((OPTIND-1)); OPTIND=1
      ;;
    esac
  done
  
  case $CLOUD_PROVIDER in
    cloudservers)
      if which dpkg &> /dev/null; then
        PRIVATE_IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
        HOSTNAME=`echo $PRIVATE_IP | tr . -`.static.cloud-ips.com
        echo $HOSTNAME > /etc/hostname
        sed -i -e "s/$PRIVATE_IP.*/$PRIVATE_IP $HOSTNAME/" /etc/hosts
        set +e
        /etc/init.d/hostname restart
        set -e
        sleep 2
        hostname
      fi
      ;;
  esac
}
