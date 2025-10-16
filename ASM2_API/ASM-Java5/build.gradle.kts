import org.jetbrains.gradle.ext.*
import groovy.util.Node
import groovy.util.NodeList
import groovy.xml.XmlParser
import groovy.xml.XmlNodePrinter
import java.io.StringWriter
import java.io.PrintWriter

plugins {
    idea
    id("org.jetbrains.gradle.plugin.idea-ext") version "1.1.10"
    id("java")
    id("org.springframework.boot") version "4.0.0-M3"
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
    implementation("org.springframework.boot:spring-boot-starter-mail")

    // Spring dev tools
    developmentOnly("org.springframework.boot:spring-boot-devtools")

    // Postgres driver
    implementation("org.postgresql:postgresql:42.7.8")

    // Lombok - compileOnly AND annotationProcessor
    compileOnly("org.projectlombok:lombok:1.18.38")
    annotationProcessor("org.projectlombok:lombok:1.18.38")

    // MapStruct
    implementation("org.mapstruct:mapstruct:1.6.3")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.6.3")

    // CRITICAL: Binding must be AFTER both Lombok and MapStruct processors
    annotationProcessor("org.projectlombok:lombok-mapstruct-binding:0.2.0")

    // Spring configuration processor - can be last
    annotationProcessor("org.springframework.boot:spring-boot-configuration-processor")

    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")

    // Commons codec (for SHA256)
    implementation("commons-codec:commons-codec:1.19.0")

    //BCrypt
    implementation("at.favre.lib:bcrypt:0.10.2")
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

tasks.register("disableAnnotationProcessorInIntelliJ") {
    doLast {
        val isIntelliJ = System.getProperty("idea.active") == "true"
        if (isIntelliJ) {
            val compilerXmlFile = file(".idea/compiler.xml")
            if (!compilerXmlFile.exists()) {
                logger.warn(".idea/compiler.xml not found; skipping modification.")
                return@doLast
            }

            val parser = XmlParser()
            val compilerXml = parser.parse(compilerXmlFile)
            val compilerConfiguration = (compilerXml as Node)
                .children()
                .find { it is Node && (it as Node).attribute("name") == "CompilerConfiguration" } as? Node

            val annotationProcessing = compilerConfiguration?.get("annotationProcessing") as? NodeList
            annotationProcessing?.forEach {
                compilerConfiguration.remove(it as Node)
            }

            val stringWriter = StringWriter()
            val nodePrinter = XmlNodePrinter(PrintWriter(stringWriter)).apply {
            }
            nodePrinter.print(compilerXml)

            compilerXmlFile.writeText(stringWriter.toString())
            logger.lifecycle("Disabled annotation processor in IntelliJ compiler.xml")
        }
    }
}

idea {
    project {
        settings {
            taskTriggers {
                afterSync(tasks.named("disableAnnotationProcessorInIntelliJ"))
            }
        }
    }
}