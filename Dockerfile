FROM  tomcat:9-jdk11
RUN apt update && apt install -y maven && apt install -y git  && git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
WORKDIR ./boxfuse-sample-java-war-hello
RUN mvn package && cp ./target/hello-1.0.war /usr/local/tomcat/webapps