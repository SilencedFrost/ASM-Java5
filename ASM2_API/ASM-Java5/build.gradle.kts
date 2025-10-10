plugins {
    id("java")
    kotlin("jvm") version "1.9.22"
    kotlin("plugin.spring") version "1.9.22"
    kotlin("plugin.jpa") version "1.9.22"
    id("org.springframework.boot") version "4.0.0-M2"
    id("io.spring.dependency-management") version "1.1.7"
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {

    // Spring boot
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    annotationProcessor("org.springframework.boot:spring-boot-configuration-processor")

    // Spring dev tools
    developmentOnly("org.springframework.boot:spring-boot-devtools")

    // Thymeleaf
    implementation("org.springframework.boot:spring-boot-starter-thymeleaf")

    // MSSQL JDBC driver
    implementation("com.microsoft.sqlserver:mssql-jdbc:12.10.1.jre11")

    // Lombok
    compileOnly("org.projectlombok:lombok:1.18.38")
    annotationProcessor("org.projectlombok:lombok:1.18.38")

    // JBcrypt
    implementation("org.mindrot:jbcrypt:0.4")

    // Mail
    implementation("org.springframework.boot:spring-boot-starter-mail")

    // Kotlin
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")

    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.test {
    useJUnitPlatform()
}

// Enable annotation processing
tasks.withType<JavaCompile> {
    options.compilerArgs.add("-parameters")
}

tasks.bootRun {
    sourceResources(sourceSets["main"])
}