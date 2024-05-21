# AWS_CI_Pipeline 

- This project is a use case of AWS Code commit, AWS Code pipeline, AWS Code Build
- Start with code build so that we can build project with all steps like Code checkout, Build and UT, Code scan, Image build, image scan and image push. After that create pipeline for orchestration.

#1. AWS Code Build

- Go to AWS Code build and create AWS Code build project as below.
- Project Name :- sample-python-flask-service

<img width="674" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/bf998a3c-8cbd-4575-bd53-b7bb48c67082">

- In source section, provide source as GitHub. If not conneceted to GitHub account, *"Connect with OAuth"* or *"Connect with GitHub personal Access token"*
- If GitHub is connected with AWS, provide repository type as *"Public repo"* or *"Repo in my GitHub account"* and provide URL

<img width="821" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/c81fe8c1-8189-42db-8654-ba0e7fd66be1">

- Go to environment section now.
  As AWS Code pipeline acts as orchestrator which invokes AWS Code build, so we need to provide environment for AWS Code build
  Here environment will be VM image or Docker image. Environment image will be managed image or custom image

  <img width="778" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/abb59051-e09f-43e5-be9b-0cbec15f301a">

  In managed images choose image required (Amazon Linux, Ubuntu or Windows). Then choose runtime and choose latest image. Here AWS code build we use as Builds service. As this is managed service, AWS will provide you images where we can run our code build on them.

- Now select "Service Role". For Code build to perform action on AWS needs service role or an IAM role. As it is service performing some action, we're using Role not IAM users. Users dont perform action here.


- Build Spec
  For all stages of pipeline to execute we need to write code which we write here. We can use Build spec file from github or we can write commands specific manually.
- Here write the stages as below.
  We can start with "Phases" stage. As per snap, we have ubuntu image with python runtime.
  Start writing pre build stage. Here we can define the requirements.txt file for our image to run as it installs dependencies.

  <img width="797" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/5ba098e3-8a37-427b-ac3f-37050f8ec228">

  Now go to build stage, write required commands to build image. Here as of now we need to build image and push to docker hub
  So in below snap we can see, we navigated to the directory (cd .), started build, executed docker commands to create image from dockerfile and push the same to Docker hub.

  <img width="378" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/66619572-2767-4dd6-8869-cc2429157740">
  We've given tage in above image as we wont update them as they are sensitive. We can store them in AWS credentials manager. If we provide user and password in tag in above snap, anyone who opens the file can use that compromising security.

- As we're only doing CI here, in post-build actions add only success statement. So our final buildspec.yml file will look like :-

<img width="805" alt="image" src="https://github.com/Shubham0315/AWS_CI_Pipeline/assets/105341138/8396b78f-6ed4-4bc1-8515-a60f1d4ac6ea">

  

    




- 



