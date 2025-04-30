// Bernoulli null model

data {
  int<lower=1> N ; // obs
  array[N] int<lower=0, upper=1> Presence ; // Response
}
parameters {
  real theta;
}
model {
  Presence ~ bernoulli_logit(theta); // no expl variables
}

