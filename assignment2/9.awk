BEGIN { 
  FS=",";
  greatest_difference = -1;
  greatest_difference_org = "";
}

{
  organization = $10;
  difference = $3 - $5;
  difference = sqrt(difference * difference);

  if (difference > greatest_difference){
    if (difference != 100){
      greatest_difference = difference;
      greatest_difference_org = organization;
    }
  }
}
END { 
  print(greatest_difference_org);
}
