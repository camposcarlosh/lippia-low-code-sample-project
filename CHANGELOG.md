<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>io.lippia</groupId>
        <artifactId>root</artifactId>
        <version>3.3.0.2</version>
    </parent>

    <groupId>com.Crowdar</groupId>
    <artifactId>lippia-low-code-sample-project</artifactId>
    <name>low-code-automation</name>
    <packaging>jar</packaging>
    <url>http://maven.apache.org</url>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <base.api.url>https://rickandmortyapi.com/api</base.api.url>
        <cucumber.stepsDefinitions>--glue io/lippia/api/lowcode/steps --glue ar/steps</cucumber.stepsDefinitions>
        <cucumber.hooks>-