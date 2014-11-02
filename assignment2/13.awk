BEGIN { FS=",";}

{
  dem_scores[$10] += $3;
  score_counts[$10]++;
}

END { 

  highest_average_org = "";
  highest_average = -1;

  for (organization in dem_scores){
    dem_score = dem_scores[organization];
    score_count = score_counts[organization];
    average = (dem_score / score_count);

    if (average > highest_average){
      highest_average = average;
      highest_average_org = organization;
    }
  }

  print(highest_average_org);
}
