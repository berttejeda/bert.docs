function enumerate(o,s){

    //if s isn't defined, set it to an empty string
    s = typeof s !== 'undefined' ? s : "";

    for(var key in o){
        // Check if the property really exists
        if(o.hasOwnProperty(key)){
            var value = o[key];
            //if value has nested depth
            if(typeof value == "object"){
                //write the key to the console
                console.log(s+key+": ");
                //recursively call enumerate on the nested properties
                enumerate(value,s+"  ");
            } else {
                //log the key & value
                console.log(s+key+": "+String(value));
            }
        }
    }
}