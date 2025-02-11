import gym
env_args = {
    # 'log_saving_path': './logs/dssat-pdi.log',  # if you want to save DSSAT outputs for inspection
    # 'mode': 'irrigation',  # you can choose one of those 3 modes
    # 'mode': 'fertilization',
    'mode': 'all',
    'seed': 123456,
    'random_weather': True,  # if you want stochastic weather
}
env = gym.make('gym_dssat_pdi:GymDssatPdi-v0', **env_args)