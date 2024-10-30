#démarrage de sql 
service mysql start  

# Démarrage de apache
service apache2 start 

# # Attendre que MySQL soit prêt 
# until mysqladmin ping >/dev/null 2>&1; do 
#      echo "En attentte de mysql..."
#      sleep 2
# done

# Afin de garder le conteneur actif 
tail -f /var/log/apache2/access/log
