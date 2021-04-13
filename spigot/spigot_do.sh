#!/bin/bash
cd ~
rm -rf spigot_src/
mkdir spigot_src
cd spigot_src
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
java -jar BuildTools.jar
