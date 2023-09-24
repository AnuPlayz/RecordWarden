# RecordWarden Backend

Welcome to the backend repository for **RecordWarden**, a blockchain-based eVault system designed for secure and transparent legal records management.

## Overview

RecordWarden's backend is the core component responsible for managing legal records, cases, and access control. This repository contains the Solidity smart contracts and server-side code necessary to power the system.

## Key Features

- **Smart Contract Integration:** RecordWarden employs Ethereum smart contracts for secure, tamper-proof record-keeping and access control.

- **Role-Based Access Control:** The system supports role-based access, with roles for Lawyers and Judges, each with specific permissions.

- **Case Management:** Legal professionals can create, update, and monitor legal cases, complete with descriptions and status tracking.

- **Document Management:** Users can upload, manage, and control access to legal documents, ensuring data privacy and security.

- **Immutable Audit Trails:** The system maintains immutable audit trails to provide transparency and accountability for all interactions.

## Getting Started

To set up and run the RecordWarden backend, follow these steps:

1. **Prerequisites:**
   - Ensure you have Node.js and npm (Node Package Manager) installed.
   - Install the required dependencies by running `npm install`.

2. **Smart Contracts:**
   - The smart contracts are located in the `contracts` directory. Compile and deploy them to the Ethereum blockchain using your preferred tool, such as Truffle or Hardhat.

3. **Private Key Configuration:**
   - Configure your private key and deployment network by specifying Ethereum node connectivity and settings in the `hardhat.config.ts` file.

4. **Scripts for the Contract:**
    - npm run compile
    - npm run source
    - npm run deploy
   
## Basic Flowchart of the Dapp

![eVault](https://github.com/AnuPlayz/RecordWarden/assets/120038186/9e0e7e86-f2cd-4c1c-9ea2-a7acad593144)

## Contributing

We welcome contributions to enhance the functionality and security of RecordWarden. Feel free to submit issues or pull requests to help make this project even better.

## Authors

- [Aniruddh Dubge](https://github.com/AnuPlayz)

## License

`SPDX-License-Identifier: UNLICENSED`

## Acknowledgments

We acknowledge the contributions and support from the blockchain and open-source community.

Thank you for choosing RecordWarden! We aim to revolutionize legal records management with security, transparency, and accessibility at its core.
