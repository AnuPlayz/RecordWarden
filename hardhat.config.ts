import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      }
    },
  },
  defaultNetwork: "mumbai",
  networks: {
    hardhat: {},
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/GonrEGE3n5YZfD0PiTI72k14Zm3Upbmn",
      accounts: ["d36772eaa33265d6aa2d302794bacc2766124158acaaa5a5d45db4c78a1587f0"],
    },
  },
  etherscan: {
    apiKey: "XNVCN1RSB7JVDWX9Y82KBJVZVW6XNDCEE3"
  },
};

export default config;
