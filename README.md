## Deploying on OpenShift.io

With the current state, this application will not work out of the box. We need to do some manual confirguration in our Che pod (bad idea), but if this is a good-to-go, then we hope on baking these changes to Che anyway.

First, go through the regular workflow of adding this codebase to your OpenShift.io project.

Then in your Che, in the terminal,
- Login to your OpenShift starter cluster (can be better done using a ServiceAccount). Get the login command from your OpenShift Web Console, from the top right drop down menu on clicking on your account name. Now paste this command in your Che terminal.

- Next, run `setup.sh` at the root of the project like `sh setup.sh`, this will install the dependencies for the project and also get the kedge binary and place it in pwd.

- Your username for OpenShift.io is generally your project name's prefix. So, project names are generally like <user>, <user-che>, <user-jenkins>, etc. We will be deploying in the <user> project, because <user-che> does not have any resources left to run a new pod. So, put this username as a value to NAMESPACE variable as below.
Modify your Run command as:
```
cd ticker-kedge-osio
NAMESPACE=<username> sh run.sh
```

- Expose your Che deployment to a service to port 5000 (this is where our Flask server wil listen on), then to a route, so we can access the Flask server from outside.
`oc expose deployment che-ws-otfek7a1kpu5bejo --port=5000 --name=ticker`
`oc expose service ticker`
Get this route name using `oc get routes` and put it under `Preview URL` in your Run command.

- That's it, code away! Make the changes and click on run, and then make changes, and click on run. Your redis will be deployed, and your changes will be reflected in real time at the preview URL shown whenever you click on Run.
