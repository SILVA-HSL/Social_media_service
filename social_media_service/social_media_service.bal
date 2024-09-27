import ballerina/http;
import ballerina/time;

type user record {|
    readonly int id;
    string name;
    time:Date birthDate;
    string mobileNumber;
|};

table<user>key(id) users=table[
    {id:1, name:"Joe", birthDate:{year:1990,month:5,day:3}, mobileNumber:"0771234567"}
];

type ErrorDetails record {
    string message;
    string details;
    time:Utc timeStamp;
    
};

type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;
    
|};

type NewUser record {|
     string name;
    time:Date birthDate;
    string mobileNumber;
    
|};

service /social\-media on new http:Listener(9090) {
    resource function get users() returns user[]|error {
       return users.toArray();
    }


    resource function get users/[int id]() returns user|UserNotFound|error {
        
        user? user=users[id];
        if user is (){
            UserNotFound notFound={
                body:{message:string `id:${id}`,details:string `user/${id}`,timeStamp:time:utcNow()}
            };
            return notFound;
        }
            return user;
    }

    resource function post users(NewUser newUser) returns http:Created|error{
        users.add({id:users.length()+1, ...newUser});
        return http:CREATED;
    }





}
