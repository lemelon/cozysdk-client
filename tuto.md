# cozysdk-client-tuto

As a developer, do you believe it’s impossible to use the resources from another application or play with data from differing applications? Well I'm here to try to prove you can. With cozy you can do things you wouldn't even imagine: you'll be able to code an application without a server and one that can communicate with all the apps on your cozy.

## Let's write a new contact application for cozy

Now, let's get serious and straight to the point: our goal is to build a serverless app with all the list of names of your Contact app. It will also be able to create, update, and delete names.

To do so, we'll proceed in different steps. We'll start slowly by deploying a serverless "Hello World" app, and we'll finish with a fully contact app with an angularjs framework. This tutorial is for everybody, from padawan to jedi, so don't be scared of it. We'll explain everything slowly.

To see the fully working and finished version, you can go on this [github](https://github.com/lemelon/cozysdk-client-tuto) repo.

### First step : Hello World !

Here we are, doing the traditionnal "Hello World" app that can make you want to start a new career. So here's the [link](https://github.com/lemelon/cozysdk-client-tuto/tree/7b4c33ce8d1281edeb5a8017191a403ee820fde4). 

First of all, you need to package the application, to build it as 'serverless': you want to tell cozy to install your app by adding {cozy-type: static} into your package.json file. Also, the index.html file needs to be at the root of your repository with a simple 'Hello World' written in it.

If you still don't know how to deploy it on your cozy, please read this instruction:

* [Package a serverless application](https://dev.cozy.io/#package-a-serverless-application-for-installation-into-your-cozy-platform)

If you managed to deploy it, congratulations! If not, don't worry, we're here to help you: the most easy way to contact us is by joining our [irc channel](http://irc.lc/freenode/cozycloud).

### Second step: Add AngularJS

#### Our objectives for this step

Here we are. Trying to test a "Hello World!" example, but on an angularJS way. This method is more like developing an app than a webpage. We'll need to create an entrance of this application, by calling ng-app="[the name of your app]" and, of course, the angularJS library. We'll also need to have a regulated main module and create a communication between the view (home.html) and the controller (Home.Ctrl.js).

#### What is AngularJS?

AngularJS is a Single Page Application (SPA) framework. If you don't have an idea of what I'm talking about, I invite you to follow the official AngularJS [tutorial](https://angularjs.org/): it explains exactly what AngularJS is and why it's advantageous for the user.

AngularJS enables the user to easily create dynamic views. It's a very used SPA, so that's why it could be a beneficial learning tool.

#### Link

* A [document](https://github.com/johnpapa/angular-styleguide) that explains how to write clean code in Angular

#### Source code

You can find the source code for this step [here](https://github.com/lemelon/cozysdk-client-tuto/tree/6db477ec69e883e0d837eee447015606b231a9b0)!

If you understand the skeleton and the main logic of this code, you basically understood what angularjs is all about.

#### The skeleton

* controllers/ -> [Here](https://docs.angularjs.org/guide/controller) you have a guide about how controllers work
* partials/ -> All the html (view) files. Templates rendered by ng-view
* vendor/ -> The different modules (library) needed for angularjs
app.module.js -> Main module (route configuration, angular lib importations...)
index.html -> The entrance point of your application

### Third step: Get user contacts from contact app

Now down to some serious business: we're ready to play with different cozy applications. We decided to interact with the "Contact" app but you can also do the same for any other application. Imagine what service you can propose to your future users. But from now on, let's synchronize with contacts by getting all the names of the app...

#### Install the contact app from the store and create or import a few of your contacts

One important part of this section, which will enable you to see the potential of what we're doing, will be the moment you install the 'Contact' app into your cozy and enter some contacts. You can for example import some contacts from google or from your mobile. You can also insert some new contacts manually.

#### Our objectives for this step

For this step, we'll have to get the list of all the names of the contact app. First of all, we'll need to create permissions in the 'package.json' file to be able to access the data of the "Contact" app. 

You'll also need to import two files into your project:

* [cozysdk-client.js](https://github.com/lemelon/cozysdk-client/blob/master/dist/cozysdk-client.js) : this is a javascript cozy library that enables to do clean request to the data-system. You can access this [tutorial](https://github.com/lemelon/cozysdk-client/blob/master/api.md) to learn how to use it.
* [cozysdk.angular.js](https://github.com/lemelon/cozysdk-client-tuto/blob/master/interfaces/cozysdk.angular.js) : this is the cozy file that enables you to connect the logic of the cozysdk-client library with angularjs. It helps developers to work with organized code in angularjs.

If you want, you can totally build the hole thing by yourself and only refer to the [data-system api](https://docs.cozy.io/en/hack/cookbooks/data-system.html), but there's a humble saying: ["do not reinvent the wheel"](https://en.wikipedia.org/wiki/Reinventing_the_wheel). So why do complicated when you can do simple?

You also need to add, in your Home.Ctrl.js file, a very simple thing : two requests of a list of name contacts inserted in your contact app. A response of this function needs to be added to scope 'home.html'. The way 'all' function is being used seems to be a bit surprizing: a function with a 'then' and a 'catch'... It's actually not that surprizing. What we're doing here is promises. It's some angularjs black magic and if you want to know more about this topic, you can follow this [link](http://www.webdeveasy.com/javascript-promises-and-angularjs-q-service/) for example. 

Also, what's important is to make controller files as simple as it can get and do all the logic in the factory repository. It's a very convincing (In My Humble Opinion) angularjs norm.

Finally, you can call an ng-repeat in the home.html file to get all the contact name list and display it. We can also put a filter to show how simple it is to add it in angularjs, just for the fun.

#### Source code

You can find the source code for this step [here](https://github.com/lemelon/cozysdk-client-tuto/tree/fff542ba62005442768179d3d96989d199dd3f7a)!

#### So what happened?

This is exactly where the magic is: two apps that have nothing to do with each other, developed by two different people that might not even know eachother, can work together and be synchronized, or, even better, rationalized. In other words, this demo proves the fact that the apps can talk to eachother. So to think a bit further, the apps can share their data to be able to give transverse services. So because our applications work in the same data space, the apps start to collaborate to deliver a more integrated user experience. They are, in a certain way, smart.

### Fourth step : Create, delete or update a contact

Ok, now we're going to have some real fun, since our framework is understood and well implemented. 

#### Our objectives for this step

The only thing we'll have to do here is to add some functions in the controller. Nothing more. The other nice thing that you'll be able to notice, is that every changes is going to refresh in the contact app instantly, even without page reloading.

The functions that we'll need are 'send', 'update', and 'destroy'. These function respectfully enables to call ['create'](https://github.com/lemelon/cozysdk-client/blob/master/api.md#createdoctype-attributes-callback), ['updateAttributes'](https://github.com/lemelon/cozysdk-client/blob/master/api.md#updateattributesdoctype-id-attributes) and ['destroy'](https://github.com/lemelon/cozysdk-client/blob/master/api.md#destroyid-callback) from the 'cozysdk.angular.js' file.

#### Source code

You can find the source code for this step [here](https://github.com/lemelon/cozysdk-client-tuto/tree/fff542ba62005442768179d3d96989d199dd3f7a)!

#### What to keep in mind?

So I've added four functions to the controller file : send, update, destroy, and updateContactList. 

The only complex call is the ‘all' request. That is why I decided to factorize it as the Contact.Fctr.js file.

### Going further

I think my role is complete. You now have the technical tool to develop serverless apps with angularjs on cozy. You can also acquire more skills on angularjs by googling it and seeing the enormous amount of tutorials on it. The challenge now will be to understand and meet the needs of a random cozy user. What new service can you offer this user, in order to simplify the managing of his or her data? You now know how to synchronise data from the different applications, so you'll need to go further and imagine what you can do with this knowledge.

When your application is going to be able to change the life of all the cozy users, you can add it on [cozy-registry](https://github.com/cozy/cozy-registry) by making a pull request.