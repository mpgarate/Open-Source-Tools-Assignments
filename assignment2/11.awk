BEGIN { FS=",";}

{

  arr[$10] += 1;

}

END { 
  
  for(polling_station in arr){
    count = arr[polling_station];
    printf("%s %s\n", count, polling_station);
  }
}
