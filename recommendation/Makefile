
ALL = kirrupt/tvrecommendation/findSimilarities/*.java

all : $(ALL)
	CLASSPATH=./:./libs/ javac -cp ".:libs/json-simple-1.1.1.jar" $(ALL)

run :
	CLASSPATH=./:/usr/share/java/mysql.jar:libs/json-simple-1.1.1.jar:libs/mysql-connector-java-5.1.28-bin.jar java kirrupt.tvrecommendation.findSimilarities.FindSimilarities


clean :
	rm */*.class */*/*.class */*/*/*.class
