import { ethers } from "hardhat";

const wait = (ms: number) => new Promise(r => setTimeout(r, ms))

/**
 * Deploys the RecordWarden contract, grants lawyer role to an admin, creates a case for Ani,
 * adds evidence to the case and logs the case details.
 */
async function main() {
  const admin = "0xc9B0b0075CC479B277f721C76dAca7A9adc3f023"

  const RecordWarden = await ethers.deployContract("RecordWarden");
  await RecordWarden.waitForDeployment();
  await wait(3000)

  let addr = await RecordWarden.getAddress()
  console.log("RecordWarden deployed to:", addr);

  console.log("Granting lawyer role to", admin)
  let addLawyer = await RecordWarden.addLawyer(admin)
  await addLawyer.wait(2)
  console.log("Lawyer role granted to", admin)

  console.log("Creating a case for Ani")
  let createCase = await RecordWarden.createCase("Ani stole a buggati", admin, new Date().getTime())
  await createCase.wait(2)
  console.log("Case created for Ani")

  let thisCase = await RecordWarden.cases(0)
  console.log("Case details:", thisCase)

  console.log("Adding evidence to case")
  let addEvidence = await RecordWarden.addCaseDocument(0, "ani.png", "bafybeiaqfndiuqfinovdjr7vrecruvm3csfofitl7swpyfvdr3uvwzqmsu")
  await addEvidence.wait(2)
  console.log("Evidence added to case")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
