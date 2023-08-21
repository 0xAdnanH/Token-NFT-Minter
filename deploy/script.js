module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const namedAccounts = await getNamedAccounts();
  const { deployer } = namedAccounts;
  await deploy("TokenSwap", {
    from: deployer,
    gasPrice: 100000000000,
    log: true,
  });
};
module.exports.tags = ["TokenSwap"];
