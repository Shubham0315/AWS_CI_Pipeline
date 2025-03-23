# AWS_CI_Pipeline 

- This project is a use case of AWS Code commit, AWS Code pipeline, AWS Code Build
- Start with code build so that we can build project with all steps like Code checkout, Build and UT, Code scan, Image build, image scan and image push. After that create pipeline for orchestration.

![image](https://github.com/user-attachments/assets/b8255c2d-d0ac-4ccf-b5b4-d74837033646)

- In GitHub create "simple-python-app"
  - This repo has veru basic flask code
 
![image](https://github.com/user-attachments/assets/8f1698ba-4530-468d-b239-1eb1bd546f8a)

  - We also have requirements file for python app (flask)
  - We've dockerfile here to build application image and push it to dockerhub. So we've python related dockerfile as well. Here we're using python based image, created WORKDIR, COPY requirements file, exposed port

![image](https://github.com/user-attachments/assets/fd697807-d8d9-4275-a3a5-f18dd07ee30a)

  - We also have buildspec.yml. We'll write this file in our pipeline.

#1. AWS Code Build

- Go to AWS Code build and create AWS Code build project as below.
- Project Name :- **python-flask-service-app**

![image](https://github.com/user-attachments/assets/9e013452-92d7-462e-a21a-57dcec2f0640)

- We can also restrict no of concurrent builds here

- In source section, provide Code Commit repo as GitHub. If not conneceted to GitHub account, *"Connect with OAuth"* or *"Connect with GitHub personal Access token"*

![image](https://github.com/user-attachments/assets/54d75c29-323c-4bcf-80af-9e25d84be103)

- Now our code build is integrated with GitHub

- If GitHub is connected with AWS, provide repository type as *"Public repo"* or *"Repo in my GitHub account"* and provide URL

![image](https://github.com/user-attachments/assets/53e0cb5f-65df-4d30-a662-b18798584b2f)

- Go to environment section now.
  - As AWS Code pipeline acts as orchestrator which invokes AWS Code build, so we need to provide environment for AWS Code build
  - Here environment will be VM image or Docker image. Environment image will be managed image or custom image

![image](https://github.com/user-attachments/assets/29578973-aa65-402d-8019-930658c2d8ce)

  - In managed images choose image required (Amazon Linux, Ubuntu or Windows). Then choose runtime and choose latest image. Here AWS code build we use as Builds service. As this is managed service, AWS will provide you images where we can run our code build on them. This is provided by AWS only
  - On contrary, in Jenkins what we do is create worker nodes on top of which we install operating systems and run pipelines on the environment. 

- Now select "Service Role". In AWS, for Code build to perform action on AWS needs service role or an IAM role. As it is service performing some action, we're using Role not IAM users. Users dont perform action here.
- Go to IAM Roles to create one like below which uses code build service and grant required permission for roles. We can give any name

![image](https://github.com/user-attachments/assets/d12e8525-5108-4a2e-8604-83e06488fbf7)


- Below is snap of adding role to our Build project

  <img width="635" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/e509e721-1819-4a00-98c7-353505173ab6">

Build Spec
- 
- For all stages of pipeline to execute we need to write code which we write here for checkout, image creation, image scanning. We can use Build spec file from github repo or we can write commands specific manually. To write manually "switch to editor"

![image](https://github.com/user-attachments/assets/990e48b3-41e0-4a06-ac69-7ba0c6ba61e0)

- Here write the stages as below.
  - We can start with "Phases" stage. Install phase, we need to select runtime needed which is python here.
 
![image](https://github.com/user-attachments/assets/8eee3c52-f361-40cd-ba3a-232d481dca0c)

  - Start writing pre build stage. Here we can define the requirements.txt file for our image to run as it installs dependencies of flask mentioned (pre-requisite)

![image](https://github.com/user-attachments/assets/1be358e0-89c2-415e-9c65-20c0abafa826)

  - Now go to build stage. We need to checkout the code which will happen automatically as we've already integrated GitHub repo.
  - Next step is to build the app, build docker image and push it. Write required commands to build image. Here as of now we need to build image and push to docker hub
  - So in below snap we can see, we navigated to the directory (cd .), started build, executed docker commands to create image from dockerfile and push the same to Docker hub.
  - To build docker image, we need to pass image name, user and password which we'll store in AWS syetems manager later. If we directly put password and username here, whoever has access to this buildspec file can use it (security)

  <img width="378" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/66619572-2767-4dd6-8869-cc2429157740">
  
  - We've given tag in above image as we wont update them as they are sensitive. We can store them in AWS credentials manager. If we provide user and password in tag in above snap, anyone who opens the file can use that compromising security.

- As we're only doing CI here, in post-build actions add only success statement. So our final buildspec.yml file will look like :-

![image](https://github.com/user-attachments/assets/f8f8d851-0bca-45db-93fb-47e7a0db7e16)

- After all is done, create project of build.

![image](https://github.com/user-attachments/assets/82089f85-0787-4aea-bf99-93e1da658851)

- To create role, go to IAM role - create role - add permissions - provide name of role

![image](https://github.com/user-attachments/assets/6a9b36f4-ef0e-4576-8c82-7cfefa8ac70f)


- If now we trigger the build, it will take code from Code Commit and will trigger build.


# Store Sensitive Information

- Go to "AWS System Manager" and go to "Parameters Store"

<img width="959" alt="image" src="https://github.com/user-attachments/assets/2c0b8d78-0001-476b-9680-1912d4274d74" />

- To create parameter - Create - Provide name (follow standard) - Select "SecureString" - Put its value at last

![image](https://github.com/user-attachments/assets/870cb4c5-3870-490a-b420-06e29750b322)
![image](https://github.com/user-attachments/assets/75c52f2f-7ce7-47a4-ac7b-925778569cab)

- While naming follow standard like project name/parameter so even if we store parameters for 100s of services, we can easily identify which parameter us for what use case. So provide in proper way and follow a standard.
  - /myapp/docker-credentials/username  :- Shubham315
  - /myapp/docker-credentials/password  :- Charger@7701
  - /myapp/docker-credentials/docker_registry_url :- docker.io  (as credentials are already provided)

![image](https://github.com/user-attachments/assets/7dc2b3d7-2482-46c7-9997-e81de48e3f3c)

---------------------------------------------------------------

# Configure Credentials in buildspec file

- Go to Code Build. Open project Details and edit buildspec.yml and pass the credentials as below
  - Use env variable as "parameter store" where we've stored our credentials
  - Instead of exposing registry in buildspec file, we can pass them in parameter store and use it from there like below format

![image](https://github.com/user-attachments/assets/bd198e2e-54a1-4c6c-b5ab-3c3fa080784c)
![image](https://github.com/user-attachments/assets/82effe2d-a554-41e4-a9c2-17797e28fbcb)

- The build and push command also need to be updated as per below.

  <img width="790" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/f68b5c70-0952-4d3a-9908-c880b9db5a6d">


-----------------------------------------------------------------

# Error Rectification

- Now start the Build for first time. It will fail at first if we have done manual errors.

1. First Failed attempt due to invalid phase names :- pre_build and post_build
   <img width="794" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/bd4548f0-d311-47f5-a7d6-e966cb3c2c66">

2. Second error is due to permissions
- Here provided the docker credentials but did not grant AWS code build access to system manager.
- We have attached role but that role doesn't have permission to talk with AWS System Manager
- Go to IAM, our role and attach policies of SSM full access (SSM is System Manager)
- Go to our role - Add permissions - Attach policies - SSM

![image](https://github.com/user-attachments/assets/0345459e-5a0a-44c6-9385-8d52f695d611)

3. Now we get 3rd error due to misconfiguration

<img width="761" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/a85356b9-7c28-44df-ad32-285f4435b38e">

- We need to provide repository name in lowecase while configuring Build project as well as in System manager parameter. Here my parameter name was in uppercase which is not acceptable.


4. Now we get below error while build failed 4th time
- Push command should not contain dot (.)

![image](https://github.com/user-attachments/assets/055fe2fc-ee73-44df-bb00-6201fb03f131)

5. Below error might be due to our credentials are not proper. Need to set additional permissions to code build

<img width="750" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/73e7033f-e898-4fb3-8b90-fa6160a52f5c">

- Go to project - Edit - Environment - Enable priviledged
- By default AWSCode build doesnt allow to create docker images on build system it provides. Click on override image option and enable "Privileged"

![image](https://github.com/user-attachments/assets/7d04b32c-0115-4b4a-a6dd-65bd5112d1e5)

- Now we can restart build. Here we missed the docker login command
- Also in push command, it should be docker.io not the URL

![image](https://github.com/user-attachments/assets/315e0dbf-c69c-4e9c-a29d-10e9bbf287ab)

- We also need to authenticate the crdentials using docker login
  - Command :-  echo "$DOCKER_REGISTRY_PASSWORD" | docker login -u "$DOCKER_REGISTRY_USERNAME" --password-stdin "$DOCKER_REGISTRY_URL"

![image](https://github.com/user-attachments/assets/973a579e-c8c4-4410-9d7f-da5b885b9dea)

- Now trigger the build project. Finally we got our CI pipeline implemented successfully.

![image](https://github.com/user-attachments/assets/ddf38147-7a69-4035-9311-b9ddcd799813)

- We can login to dockerhub to check if the image is pushed there. After resolving all errros, we have successuflly pushed our image to docker hub with "latest" tag

![image](https://github.com/user-attachments/assets/dc49bebe-dcf6-49c1-9208-0c59df191793)




#2 AWS Code Pipeline

- Till now, we are triggering build manually. We need to integrate the code build with pipeline. Pipeline has to be triggered automatically which is to be done by Code Pipeline when change is oushed to github repository.

- Go to Code Pipeline and create as "python-app". Connect to GitHub (Version2)
- This connection is established as when code commit is done, it will auto trigger pipeline for the build.

![image](https://github.com/user-attachments/assets/0be1ac2f-54b2-4535-808c-8104ac62562c)
![image](https://github.com/user-attachments/assets/0e2ce052-22ef-41c6-8dee-a9c5f43db219)

- Give Source provider as "GitHub " and connect to github - Provide connection name and connect. So when there is change in GitHub, it has to send request to pipeline to invoke. So connection is required
  - Provide repo name - Branch name

![image](https://github.com/user-attachments/assets/52438509-8449-4c44-9b94-ac63741f7754)

- Give build provider - Project name (auto fetched)

![image](https://github.com/user-attachments/assets/031cfda0-bb27-497a-92ed-e4f4ec6d653b)


- By this way our CI Pipeline is created !!! If we commit any change in repository, pipeline gets triggered automatically.

![image](https://github.com/user-attachments/assets/940bddb7-5a36-4528-bc6d-fa7fccbd95de)



#3. AWS Code Deploy

- Open code deploy

![image](https://github.com/user-attachments/assets/49db0acd-3127-4f7b-a1a2-ed7ba0607a3d)

- Go to applications - Create application - Provide name - Choose compute platform(EC2) - Create
  - In our organization we might've multiple apps like microservices.For each one we need to create app.
 
![image](https://github.com/user-attachments/assets/1b11a6e8-2d71-4ceb-8d4b-f85d85fc85b2)
![image](https://github.com/user-attachments/assets/1d20fc4b-e9fa-468f-9690-f9ce75e8f11b)

- Now our goal is to deploy the app on EC2 instance. So we'll need EC2 instance to host our app

![image](https://github.com/user-attachments/assets/b68aa40d-d3ba-4d23-a7c2-eccc088c3091)
![image](https://github.com/user-attachments/assets/09acae5c-164c-460d-9114-ae62308d0b84)

- For every AWS resource we can create tags (unique identifier). To differentiate EC2 amongst teams.
  - Go inside instance - Actions - Instance settings - Manage tags

<img width="959" alt="image" src="https://github.com/user-attachments/assets/a2fc1290-ee04-454b-a947-cf4e27f428a2" />

  - For any created resources for application(suppose payments), we can use tags. This will help DevOps engineers to keep track of resources created. So instead of going to resources and check what is created, we can just filter using tags. We can pass key-value pairs to get entire list of resources.
  - Tags can be multiple depending on requirement.

![image](https://github.com/user-attachments/assets/ae54afce-5209-4ef5-a875-5cea97f2dd0d)
![image](https://github.com/user-attachments/assets/b1d2dd5d-deae-492d-bdbe-c4de27f00c42)

  - The tag "sample-python" created will be used by code-deploy service. There can be multiple EC2 instances in AWS account of same name so we can use tags concept.
  - Code deploy can be used to deploy on multiple EC2 instances as well.

- Now we need to install agent inside EC2 - Code deploy agent (Just like jenkins
  - Go to EC2 instance - Connect
  - sudo apt update
  - sudo apt install ruby-full
  - sudo apt install wget
  - Install runner (bucket name for Ohio region from google) :- wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install

![image](https://github.com/user-attachments/assets/b6c10092-748a-44c3-b286-a00f5c52b3d5)

  - chmod +x ./install
  - sudo ./install auto
  - To check service status (started by default) :- **sudo service codedeploy-agent status**

![image](https://github.com/user-attachments/assets/c1849ce0-7bfa-4742-a344-35d1d45b0afd)

  - If we get No codedeploy agent running :- **sudo service codedeploy-agent start**

- Now we've to give permissions to the EC2.
  - Create role for EC2 and grant it permission to talk to Code deploy.
  - Go to IAM - Create role
 
![image](https://github.com/user-attachments/assets/a76d3248-ba95-40c8-b8a8-34ceca29f21a)
![image](https://github.com/user-attachments/assets/d4acb79c-3d7e-48af-904e-e3176d3c17ef)

  - Now assign the role to EC2 - Go to instances - Actions - Security - Modify IAM role

![image](https://github.com/user-attachments/assets/667f5988-4ca6-4962-b792-1e3c4445d19d)

- Now restart the service :- **sudo service codedeploy-agent restart**
  - If we dont restart, agent within EC2 wont be able to communicate to code deploy
 
- Now configure code-deploy
  - We've created the application till now in code deploy
  - Provide EC2 as an agent in code deploy first
  - There can be 100s of apps inside code deploy so to map app to correct EC2 this needs to be done (provide target group)
  - Create deployment group - Provide name - Enter service role - Select deployment type (simple or blue-green) - Provide environment configuration (key-value) - Here we get 1 matching instance (tags) - Create deployment group
 
![image](https://github.com/user-attachments/assets/487919ce-1443-4da1-89da-866bccc7afd2)
![image](https://github.com/user-attachments/assets/c023b326-ed24-4fd4-927a-d81388c3c096)
![image](https://github.com/user-attachments/assets/8d461f7f-3ac7-4243-98e8-5c18670bd1b1)
![image](https://github.com/user-attachments/assets/55081e95-e97b-43d8-aa07-85f19c01a21b)

- We've created Code deploy app, created EC2 for it and integrated both of them. Now we've to deploy app.

- For code-deploy we've appspec.yml file. We'll put this file in our GitHub repo and we've to create deployment inside application of code-deploy.
  - Create deployment - Provide deployment group - Select revision type (App hosted on S3 or GitHub) - Provide token - Provide repo name - Provide commit ID (latest from GitHub) - Create deployment
  - We've to provide commit ID to verify if our CDel is working fine or not.

![image](https://github.com/user-attachments/assets/4f6b7791-60ce-4bdb-bb74-8983956a2a96)
![image](https://github.com/user-attachments/assets/d9553b1c-3d51-4d90-b940-30a6512b431b)

  - But now when we check our deployment, our deployment process fails as appsepc.yml has to be at the root of our repo. (unlike builspec.yml which we can write at any location)

![image](https://github.com/user-attachments/assets/b3f74ebf-aaf0-4fca-bc03-f9c288586ff5)

- We've our application puhsed to dockerhub.
  - Write start and stop container now as below and commit the files

![image](https://github.com/user-attachments/assets/bb9aad3f-07b8-4052-a029-499e26a054af)
![image](https://github.com/user-attachments/assets/468c5a02-b268-4014-82b3-1a963f5525e3)

- Now as we've made some changes, delete the deployment orcreate new deployment

![image](https://github.com/user-attachments/assets/2eb3fb2f-0166-4279-a270-9c4f972769ed)

  - Now we can go inside depployment and check events
  - Install docker :- **sudo apt install docker**

![image](https://github.com/user-attachments/assets/06ca8f11-22cd-46a4-9838-854d9bdff956)

  - Now run the deployment it will get succeeded.

- Now go to code pipeline and add one more stage to it
  - Edit - Add stage - Name as code-deploy - Edit action as below
 
![image](https://github.com/user-attachments/assets/76262e96-2b54-40f8-a476-e84256a2aff8)

- Now when we check our pipeline, we've below stages
  - Source stage (commit)
  - Code build
  - Code deploy
 
![image](https://github.com/user-attachments/assets/3ba427fe-585a-4365-b1db-616202aba6f5)


-----------------------------------------------------------------------------

Overview of Project
-
- Instead of code commit we've used GitHub which triggeres code pipeline which triggers code build first and then triggers code deploy
- When code deploy is triggered, new image will be pushed to docker registry
