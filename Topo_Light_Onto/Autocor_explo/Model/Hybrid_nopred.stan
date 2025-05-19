// Bernoulli environment (light + topo) + ontogeny 
// Estimates the parameters of the developed form (∝ , β1, β2) of the quadratic equation,
// constraining them in concave form (β2 < 0; β1 ⋲ [-7*2β2; 0]).
// We define the concave form parameters (a, O, gamma) in transformed parameters,
// and the equation remains a(x - O)2 + gamma.

data {
  int<lower=1> N ; // obs
  array[N] int<lower=0, upper=1> Presence ;
  vector[N] Light ;
  vector[N] Topography ;
  vector[N] DBH ;
}
parameters {
  real<lower=-10, upper=10> beta2_p;  
  // real<lower=-300, upper=-0.02> beta2;
  real<lower=7*2*-exp(beta2_p), upper=0> beta1;
  real alpha;
  real tau; // slope of the topography effect
  real iota; // ontogeny effect
}
transformed parameters {
  real beta2 = -exp(beta2_p); // beta2<0 : forced for a concave form
  real a = beta2;
  real O = -beta1/(2*beta2);
  real gamma = alpha-beta1^2/(4*beta2);
}
model {
  // Presence ~ bernoulli_logit(alpha + beta1*Environment + beta2*Environment.*Environment); // developped Likelihood
  Presence ~ bernoulli_logit(a * (Light - (O + iota*DBH))^2 + gamma + tau*Topography); // canonic Likelihood (affine)
  // Priors
  iota ~ normal(0, 0.7); // to keep O in env range at each DBH
}

