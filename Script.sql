3 files 
- /etc/rc.d/init.d/oracle
  Like this 

/*==============================================================*/
/*=========================copy next*===========================*/
/*==============================================================*/

#!/bin/sh
# oracle: Start/Stop Oracle Database 11g R2
#
# chkconfig: 345 90 10
# description: The Oracle Database is an Object-Relational Database Management System.
#
# processname: oracle


. /etc/rc.d/init.d/functions

LOCKFILE=/var/lock/subsys/oracle
ORACLE_HOME=/oracledb/app/product/11.2.0/dbhome_1
ORACLE_USER=oracle

case "$1" in
'start')
   if [ -f $LOCKFILE ]; then
      echo $0 already running.
      exit 1
   fi
   echo -n $"Starting Oracle Database:"
   su - $ORACLE_USER -c "$ORACLE_HOME/bin/lsnrctl start"
   su - $ORACLE_USER -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME"
   su   $ORACLE_USER -c  $ORACLE_HOME/bin/dbstart
	su $ORACLE_USER -c "/home/oracle/scripts/startup.sh >> /home/oracle/scripts/startup_shutdown.log 2>&1"
	echo -n $"Oracle DataBase Started Ya Man PingooO"
   su - $ORACLE_USER -c "$ORACLE_HOME/bin/emctl start dbconsole"
   touch $LOCKFILE
   ;;
'stop')
   if [ ! -f $LOCKFILE ]; then
      echo $0 already stopping.
      exit 1
   fi
   echo -n $"Stopping Oracle Database:"
   su - $ORACLE_USER -c "$ORACLE_HOME/bin/lsnrctl stop"
   su - $ORACLE_USER -c "$ORACLE_HOME/bin/dbshut"
   su - $ORACLE_USER -c "$ORACLE_HOME/bin/emctl stop dbconsole"
   rm -f $LOCKFILE
   ;;
'restart')
   $0 stop
   $0 start
   ;;
'status')
   if [ -f $LOCKFILE ]; then
      echo $0 started.
      else
      echo $0 stopped.
   fi
   ;;
*)
   echo "Usage: $0 [start|stop|status]"
   exit 1
esac

exit 0



/*==============================================================*/
/*==============================================================*/
/*==============================================================*/

# mkdir -p /home/oracle/scripts
# chown oracle.oinstall /home/oracle/scripts


gedit This /home/oracle/scripts/startup.sh like the following 
/*==============================================================*/
/*==============================================================*/
/*==============================================================*/
#!/bin/bash

export TMP=/tmp
export TMPDIR=$TMP
export ORACLE_BASE=/u01/app/oracle
#export ORACLE_HOSTNAME=ol6-112.localdomain
#export ORACLE_UNQNAME=DB11G
#export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export ORACLE_HOSTNAME=ol6-121.localdomain
export ORACLE_UNQNAME=db12c
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/db_1
export PATH=/usr/sbin:$ORACLE_HOME/bin:$PATH

export ORACLE_SID=db12c
ORAENV_ASK=NO
. oraenv
ORAENV_ASK=YES

# Start Listener
lsnrctl start

# Start Database
sqlplus / as sysdba << EOF
STARTUP;
EXIT;
EOF

/*==============================================================*/

gedit This /home/oracle/scripts/shutdown.sh like the following 

/*==============================================================*/


#!/bin/bash

export TMP=/tmp
export TMPDIR=$TMP
export ORACLE_BASE=/u01/app/oracle
#export ORACLE_UNQNAME=DB11G
#export ORACLE_HOSTNAME=ol6-112.localdomain
#export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export ORACLE_HOSTNAME=ol6-121.localdomain
export ORACLE_UNQNAME=db12c
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/db_1
export PATH=/usr/sbin:$ORACLE_HOME/bin:$PATH

export ORACLE_SID=db12c 
ORAENV_ASK=NO
. oraenv
ORAENV_ASK=YES

# Stop Database
sqlplus / as sysdba << EOF
SHUTDOWN IMMEDIATE;
EXIT;
EOF

# Stop Listener
lsnrctl stop
/*==============================================================*/
/*==============================================================*/
/*==============================================================*/


# chmod u+x /home/oracle/scripts/startup.sh /home/oracle/scripts/shutdown.sh
# chown oracle.oinstall /home/oracle/scripts/startup.sh /home/oracle/scripts/shutdown.sh





/*==============================================================*/
/*===========================OPCIONAL===========================*/
/*==============================================================*/ 

you can try this simply [Not Sure]


Create a file called "/etc/init.d/dbora" as the root user, containing the following.

    #!/bin/sh
    # chkconfig: 345 99 10
    # description: Oracle auto start-stop script.
    #
    # Set ORA_OWNER to the user id of the owner of the 
    # Oracle database software.

    ORA_OWNER=oracle

    case "$1" in
        'start')
            # Start the Oracle databases:
            # The following command assumes that the oracle login 
            # will not prompt the user for any values
            su $ORA_OWNER -c "/home/oracle/scripts/startup.sh >> /home/oracle/scripts/startup_shutdown.log 2>&1"
            touch /var/lock/subsys/dbora
            ;;
        'stop')
            # Stop the Oracle databases:
            # The following command assumes that the oracle login 
            # will not prompt the user for any values
            su $ORA_OWNER -c "/home/oracle/scripts/shutdown.sh >> /home/oracle/scripts/startup_shutdown.log 2>&1"
            rm -f /var/lock/subsys/dbora
            ;;
    esac

Use the chmod command to set the privileges to 750.

    chmod 750 /etc/init.d/dbora

Associate the dbora service with the appropriate run levels and set it to auto-start using the following command.

    chkconfig --add dbora
	
/*==============================================================*/
/*==============================================================*/
/*==============================================================*/

in Error of Starting up >>no service in listener this is listener.ora

# listener.ora Network Configuration File: /oracledb/app/product/11.2.0/dbhome_1/network/admin/listener.ora
# Generated by Oracle configuration tools.
SID_LIST_LISTENER =
 (SID_LIST =
   (SID_DESC =
     (SID_NAME = ORCL)
     (ORACLE_HOME = /oracledb/app/product/11.2.0/dbhome_1)
     (PROGRAM = extproc)
   )
 (SID_DESC=
       (GLOBAL_DBNAME=ORCL)
       (ORACLE_HOME=/oracledb/app/product/11.2.0/dbhome_1)
       (SID_NAME=ORCL)
  )
 )
SUBSCRIBE_FOR_NODE_DOWN_EVENT_LISTENER=OFF
LISTENER =
 (DESCRIPTION_LIST =
   (DESCRIPTION =
     (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1))
     (ADDRESS = (PROTOCOL = TCP)(HOST =127.0.0.1)(PORT = 1521))
   )
 )

ADR_BASE_LISTENER = /oracledb/app

/*==============================================================*/
/*==============================================================*/
/*==============================================================*/

Solución de un errror en caso de presentarce. 
http://www.oracledistilled.com/oracle-database/troubleshooting/error-cannot-restore-segment-prot-after-reloc-permission-denied/
chmod -R 775 /etc/rc.d/init.d/*