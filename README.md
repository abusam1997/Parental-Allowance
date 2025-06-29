# Parental-Allowance Smart Contract

A Clarity smart contract for managing parental allowances on the Stacks blockchain. This contract allows a parent to register children, pause/resume allowances, and send weekly STX payments to registered children.

## Features

- **Register Child:** Only the contract owner (parent) can register a child.
- **Pause/Resume Allowance:** Temporarily pause or resume a child's allowance.
- **Send Weekly Allowance:** Parent can send a fixed weekly allowance to registered, unpaused children.
- **Track Last Payment:** Keeps track of the last block height when allowance was sent.
- **Read-Only Functions:** Check if a child is paused and get the last payment block.

## Contract Functions

### Public Functions

- `register-child (child principal)`  
  Registers a new child. Only callable by the contract owner.

- `pause-allowance (child principal)`  
  Pauses a child's allowance. Only callable by the contract owner.

- `resume-allowance (child principal)`  
  Resumes a paused allowance. Only callable by the contract owner.

- `send-weekly (child principal) (current-block uint)`  
  Sends the weekly allowance to a child if eligible. Only callable by the contract owner.

### Read-Only Functions

- `is-paused (child principal)`  
  Returns `true` if the child's allowance is paused.

- `get-last-paid (child principal)`  
  Returns the block height of the last payment to the child.

## Constants

- `contract-owner` — The deploying address (parent).
- `allowance-amount` — Amount of STX sent as weekly allowance (default: 1 STX).

## Usage

1. **Deploy the contract** to the Stacks blockchain.
2. **Register children** using the `register-child` function.
3. **Pause or resume** allowances as needed.
4. **Send weekly allowance** by calling `send-weekly` with the child's principal and current block height.

## Requirements

- [Stacks blockchain](https://www.stacks.co/)
- Clarity smart contract language

## Example

```clarity
;; Register a child
(register-child 'SP2C2...XYZ)

;; Pause a child's allowance
(pause-allowance 'SP2C2...XYZ)

;; Resume a child's allowance
(resume-allowance 'SP2C2...XYZ)

;; Send weekly allowance
(send-weekly 'SP2C2...XYZ u12345)
