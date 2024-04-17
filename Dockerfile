FROM tomcat
COPY target/*.war webapps
EXPOSE 8080clear
