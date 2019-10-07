node {
    stage('checkout'){
        //必须有，该checkout步骤将检出从源控制代码; scm是一个特殊变量，指示checkout步骤克隆触发此Pipeline运行的特定修订。
        echo "checkout from git repo..."
        checkout scm
    }

    //未解决问题：version 变量怎样传进来 或则怎样设置，每次构建和发布时自动累加

    //修改为当前的模块名称
    def moduleName="eureka-server"

    //设置服务端口号（全局唯一，不能重复，网关根据这个端口号查找服务)
    def exposePort="8761"

    //容器运行的端口号，与服务端口号保持一致
    def containerPort="8761"

    //maven 路径设置：jekins插件管理->全局工具配置->Manven安装
    def mvnHome = tool('mvn3')

    //maven工作路径添加到Linux全局环境变量路径下
    env.PATH = "${mvnHome}/bin:${env.PATH}"

    //env.WORKSPACE是jenkins当前的工作路径；
    def projHome="${env.WORKSPACE}/${moduleName}"

    //maven在项目里构建jar包的位置
    def targetDir="target"

    def jarHome="${projHome}/${targetDir}"

    //所有项目的镜像构建后统一命名
    def app="app.jar"

    //公司domain
    def domain="chp"

    //docker iamge tag
    def tag="${domain}/${moduleName}"

    //工程日志目录
    def projLog="${env.WORKSPACE}/logs"

    //容器日志目录
    def containerLog="/home/logs"

    //容器工作目录
    def contianerWorkDir="/home"

    //contain jar
    def containerApp="${contianerWorkDir}/${app}"

    //gc日志
    def gcLog="${projLog}/gc.log"

    stage('maven build'){
        sh "mvn  clean package -U -Dmaven.test.skip=true"
    }

    stage('docker build'){

        sh "mv ${jarHome}/${moduleName}-*.jar ${jarHome}/${app}"

        def containerId= sh returnStdout: true ,script: "docker ps -a|grep '${tag}' | awk '{print \$1}'"

        def runningPort=  sh returnStdout: true ,script: "netstat -ntulp|grep '${exposePort}'|sed -n '1,1p' | awk '{print \$4}'"

        sh "echo containerId= ${containerId} && echo runningPort=${runningPort}"

        if(null!="${runningPort}"){

            sh "docker stop ${containerId}"
        }

        if(null!="${containerId}"){
            sh "docker rm ${containerId}"
        }

        def imageId= sh returnStdout: true ,script: "docker images|grep'${tag}'|sed -n '1,1p' | awk '{print \$3}'"

        sh "echo imageId=${imageId}"

        if(null!="${imageId}"){
            sh "docker rmi -f ${tag}"
        }

        //构建镜像
        sh "docker build -t ${tag} ."
    }

    stage('deploy'){

        def logPath= sh returnStdout: true ,script: "ls ${projLog}"

        if(null=="${logPath}"){
            sh "mkdir ${projLog} && chown 777 ${projLog}"
        }

        //运行容器，换行时首尾留空格
        sh "docker run -d --restart=on-failure:5 --privileged=true "+
                " -w ${contianerWorkDir} "+
                " -v ${projLog}:${containerLog} "+
                " -p ${exposePort}:${containerPort} "+
                " --name ${moduleName} ${tag} "+
                " java "+
                    " -Djava.security.egd=file:/dev/./urandom "+
                    " -Duser.timezone=Asia/Shanghai "+
                    " -XX:+PrintGCDateStamps "+
                    " -XX:+PrintGCTimeStamps "+
                    " -XX:+PrintGCDetails "+
                    " -XX:+HeapDumpOnOutOfMemoryError "+
                    " -Xloggc:${gcLog} "+
                    " -jar ${containerApp} "
    }
}