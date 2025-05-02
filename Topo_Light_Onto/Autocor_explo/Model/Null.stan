// Bernoulli null model

data {
  int<lower=1> N ; // obs
  array[N] int<lower=0, upper=1> Presence ; // Response
}
parameters {
  real theta ;
}
model {
  Presence ~ bernoulli_logit(theta) ; // no expl variables
}
generated quantities { // predictions
vector<lower=0, upper=1>[N] p ;
p = rep_vector(inv_logit(theta), N) ; // replicate the real
}

