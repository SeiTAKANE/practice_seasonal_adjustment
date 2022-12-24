//　状態空間モデルを使った季節調整

//入力データの定義
data {
  int T;
  vector[T] y;
}

//パラメータの設定
parameters {
  vector[T] mu; //トレンド成分
  vector[T] gamma; //季節性成分
  real<lower=0> s_z; //トレンド成分の確率変動
  real<lower=0> s_s; //季節性成分の確率変動
  real<lower=0> s_v; //観測値の誤差
}

#中間的なパラメータ
transformed parameters {
  //トレンド成分+季節性成分から得られる状態推定値α
  vector[T] alpha;
  for(i in 1:T){
    alpha[i] = mu[i] + gamma[i];
  }
}

//モデル
model {
  for(i in 3:T){
  //トレンド成分
    mu[i] ~ normal(2*mu[i-1] - mu[i-2], s_z);
  }
  //季節性成分
   for(i in 12:T){
    gamma[i] ~ normal(-sum(gamma[(i-11):(i-1)]), s_s);
  }
  //観測値
   for(i in 1:T){
    y[i] ~ normal(alpha[i], s_v);
  }
}

