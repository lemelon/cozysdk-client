# cozysdk-client

SDK for cozy apps without a server.

If you want to understand how to write an app without a server with cozy, you can also follow this [tutorial](https://github.com/lemelon/cozysdk-client/blob/master/tuto.md).

## What is it for?

cozysdk-client is a native library that enables serverless applications to make requests directly to the data-system in a simple way. 

## Why this documentation?

This documentation is for developers who want to interact with the data-system without building a server. In other words, it's a documentation for users who write serverless applications.

## What's inside?

To work with this library, you'll need to use the following functions:

### create(docType, attributes, callback)

This enables the user to add a new item.

#### What is 'docType'?

You need to enter the docType, so for example if you want to define a request to get all the contacts, you'll have to add "Contacts" as a docType name. You also need to make sure that you added the permissions in the package.json like so:

    "cozy-permissions": {
        "Contact": {
            "description": "To easily find your contact when talking about someone."
        }
    }

This is just an example but if you want to work with Emails for example, you'll just need to add "Message" as a cozy-permission and name it as a docType in the define function.

#### What are 'attributes'?

Attributes are the json object with the new fields that are added to the database. So for example if I want to add a user contact with bob as a name, I need to add a json object as an attribute as followed:

     {"n": "bob"}

The "n" letter is used because this is how the document field has been updated in the couchdb data-system by the user who has coded the "Contact" app.

#### A simple example

    create("Contact", {"n": "bob"}, function(response) {
        // You can get the id with response.id
    });

#### What is the response?

The response of this request will be the id of the new document that had been added.

### find(docType, id, callback)

#### A simple example

    find("Contact", [id of what you want to find], function(response) {
         // The response will be the data of all the document of this specific id
     });

This enables the user to get the data of a specific id.

#### What is the response?

The response of this request will be a json object with the data of the id that has been used.

### updateAttributes(docType, id, attributes)

This enables the user to update a document.

### destroy(docType, id, callback)

This enables the user to delete a specific document from the database.

### defineRequest(docType, name, request)

This enables the user to define a request by using the MapReduce method and define a document from their original structure into a new key/value pair. You can then choose to map only a specific field of a document. Here, for example, is a function that can Map the name field of a contact document.

    function(doc) {
        if (doc.n) {
            emit(doc.n);
		}
    }


The call to the emit function is when the mapping takes place. The emit function accepts two arguments: a key and a value. Both arguments are optional and will default to null if omitted. As it's helpful to know which document the mapped data came from, the id of the mapped document is also automatically included.

##### What is 'name'?

The second param is the name of the request you want to create. So for example, if you want to get a contact that starts with an "a", you just need to create a name like "contactthatstartswithana” in order to run it afterwards. It might also be useful to have some [conventions](https://ehealthafrica.github.io/couchdb-best-practices/#naming-conventions-for-views) to requests/views.

#### What is 'request'?

The third param is the actual request that needs to be made to communicate with the cozy database. You need here to present the third params :
* Either as a string : `'function(doc) { emit(doc.n, null); }'`
* Or you can put the function directly, like this : function(doc) { emit(doc.n, null); }
* Or finally as an object with map and reduce :  {map: "function(doc) { emit([doc.year, doc.month, doc.day], 1); }", reduce: "_sum"}

The purpose of this is that you can easily customize your request and use whenever you wish in your app.

#### A simple example

Imagine you have a cozy database with contact records and you want a view of those records using the name of each user as keys. If so, you can easily do the following:


    defineRequest("Contact", "lastName", function(doc) {
        if (doc.n) {
            emit(doc.n, doc);
        }
     });


If you run this function [run(docType, name, params)], you will have a result like this:

    [
       ...
       { key: "Clarke", value: { n: "Clarke", ... } },
       { key: "Kelly",  value: { n: "Kelly",  ... } },
       { key: "Smith",  value: { n: "Smith",  ... } },
       ...
    ]

### run(docType, name, params, callback)

This enables the user to run a request that has been defined by defineRequest(docType, name, request). The response is an id, a key and a value.
* 'The keys' is an array in which each of the elements contains a key from the map function and the id of the document that produced it.
* Values is an array of the values produced by the map function.

#### What is 'params'?

Params enables the user to fine tune what he or she wants to get.

* key: only returns document for this key
* keys: [only returns document for this array of keys]
* limit: number of documents to return
* skip: number of documents to skip
* startKey: only returns document after this key
* endKey: only returns document before this key

So for example the param could look like this:

    {key: 'bob'}

In this case, when you run the function with this param, the only documents that will be retrieved, will be those that have 'bob' as a name.

### requestDestroy(docType, name, params, callback)

This enables the user to destroy a document that has been matched with defineRequest(docType, name, request).
