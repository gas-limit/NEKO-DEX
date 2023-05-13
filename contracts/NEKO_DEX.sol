//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title NEKO DEX Liquidity Pool
/// @author gas-limit.eth
/// @notice This contract establishes a liquidity pool for the NEKO DEX, allowing users to contribute liquidity and make a positive difference in the lives of cats requiring assistance.
/// Charitable organizations benefit from a 0.3% fee imposed on all trades, which is utilized to finance cat rescue operations.
/// @dev This contract is based on the Uniswap V2 Pair contract.

/*
⠀⠀⠀⠀⠀⠀⠀⢀⡖⣛⡒⠤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⢖⣛⡳⡄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢸⢹⠁⠈⠙⣦⠉⠓⢶⢻⣿⢹⣿⢓⡖⠒⠋⢡⡞⠉⠀⢱⣳⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⡇⠸⠤⠔⠊⠁⠀⠀⠘⠾⠙⠞⠙⠟⠀⠀⠀⠀⠉⠒⠤⠼⢹⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⣀⣠⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣀⡀⠀⠀⠈⣇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡎⠀⠀⠀⠘⠛⠉⠉⠻⠆⠀⠀⠀⠀⠀⠀⠾⠋⠉⠙⠛⠀⠀⠀⠸⡆⢀⣠⣤⣄⡀⠀
⠀⠀⠀⠀⠀⢸⠀⠖⠒⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡒⠒⠒⣿⠋⢳⡄⢳⠹⡆
⠀⠀⠀⠀⠀⣹⠐⢛⣉⣭⠄⠀⠀⠰⣦⣀⣀⣠⠴⢦⣄⣀⣀⣠⠄⠀⠀⢸⣍⣉⠓⢽⣤⣼⣥⣾⣤⠇
⠀⠀⠀⠀⠀⠸⡆⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠉⢁⣟⠀𝐍 𝐄 𝐊 𝐎⠈⡇⠀
⠀⠀⠀⠀⠀⣰⣿⢦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⡿⠀⠀𝐃 𝐄 𝐗⠀⢰⡇⠀
⠀⠀⠀⣠⠞⠁⠙⢾⣼⣽⠷⣶⣶⢤⡤⣤⣤⣤⣤⣤⣤⣤⡤⣤⢴⠶⡖⣿⣿⠼⠛⠎⠎⠎⠎⢀⠞⠀⠀
⠀⠀⣰⠃⠀⠀⠀⣼⢋⢹⡀⡎⢹⢾⣦⣷⠛⠉⠙⢷⠾⢦⡧⠼⠾⠛⠋⠉⠀⠀⠀⠀⠐⣤⠎⠀⠀⠀
⢀⣾⣻⠀⠀⠀⠀⠹⣟⡭⠟⢹⠟⠾⣆⣻⡀⠰⡆⣸⢤⡄⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀
⢸⣇⠻⣄⠀⠀⠀⢀⡐⢷⡖⢛⣰⠉⣋⣹⣏⡛⠛⠣⠼⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡇⠀⠀⠀
⠘⣇⡙⣿⣦⣀⠀⠀⠉⣷⣟⣇⣨⣿⠟⠉⠉⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀
⠀⠻⣌⣹⣣⠈⡟⢳⣞⣽⣥⣼⣟⣥⡄⠀⢀⣸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠇⠀⠀⠀
⠀⠀⠈⠛⢧⡀⡗⢋⣉⠭⣽⣿⡉⠛⠁⢀⠏⡴⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠙⣏⠁⣠⠖⢹⣿⣇⠀⠀⠘⣄⣧⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠴⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠓⠳⠖⠛⠿⠿⣷⣖⣉⣁⣀⣀⣀⣀⣀⣀⣀⣤⠤⠴⠒⠊⠉⠀⠀⠀⠀⠀⠀⠀⠀
 */

contract NEKO_DEX is ERC20 {
    
    IERC20 public token0; // first asset   
    IERC20 public token1; // second asset
    address public feeReceiver; // charity foundation address

    /// @notice Creates a new liquidity pool for the given assets.
    /// @param _token0 The first asset.
    /// @param _token1 The second asset.
    /// @param _feeReceiver The charity foundation address.
    /// @param _name The name of the liquidity token.
    /// @param _symbol The symbol of the liquidity token.
    constructor(IERC20 _token0, IERC20 _token1, address _feeReceiver, string memory _name, string memory _symbol) ERC20(_name,_symbol) {
        token0 = _token0; 
        token1 = _token1; 
        feeReceiver = _feeReceiver; 
    }

    /*//////////////////////////////////////////////////////////////
                            LIQUIDITY LOGIC
    //////////////////////////////////////////////////////////////*/


    /// @notice deposit tokens to the liquidity pool
    /// @param token0Amount The amount of the first asset to deposit.
    /// @param token1Amount The amount of the second asset to deposit.
    function addLiquidity(uint256 token0Amount, uint256 token1Amount) external {
        require(token0Amount > 0 && token1Amount > 0, "Invalid token amounts");

        // transfer tokens from sender to this contract
        token0.transferFrom(msg.sender, address(this), token0Amount); 
        token1.transferFrom(msg.sender, address(this), token1Amount); 

        // calculate liquidity
        // How is liquidity calculated? liquidity is calculated:
        // as the minimum of the two amounts multiplied by the total supply of the pool divided by the reserves of the token in the pool.
        // liquidity = min(x*totalSupply/xPool, y*totalSupply/yPool)
        // x is the amount of token0, y is the amount of token1
        // totalSupply is the total supply of the liquidity token
        // xPool is the amount of token0 in the pool, yPool is the amount of token1 in the pool
        // if the pool is empty, the liquidity is the square root of the product of the two amounts
        // for example, if the pool is empty, and the user deposits 1000 token0 and 1000 token1, the liquidity is sqrt(1000*1000) = 1000
        // if the pool is not empty, and the user deposits 1000 token0 and 1000 token1, the liquidity is min(1000*1000/1000, 1000*1000/1000) = 1000
    
        uint256 liquidity = 0;
        uint256 _totalSupply = totalSupply();
        // if the pool is empty, the liquidity is the square root of the product of the two amounts
        if (_totalSupply == 0) {
            // liquidity = sqrt(x*y)
            liquidity = sqrt(token0Amount * token1Amount); 
        } else {
            // liquidity = min(x*totalSupply/xPool, y*totalSupply/yPool)
            liquidity = min(token0Amount * _totalSupply / token0.balanceOf(address(this)), token1Amount * _totalSupply / token1.balanceOf(address(this))); 
        }

        require(liquidity > 0, "Insufficient liquidity");
        // mint liquidity tokens to sender
        _mint(msg.sender, liquidity);
    }

    /// @notice remove liquidity from the liquidity pool
    /// @param liquidity The amount of liquidity to remove.
    /// @dev The amount of liquidity to remove must be greater than 0.
    /// @dev The amount of liquidity to remove must be less than or equal to the total supply of the liquidity token.
    function removeLiquidity(uint256 liquidity) external {
        require(liquidity > 0, "Invalid liquidity amount");
        require(liquidity <= totalSupply(), "Insufficient liquidity");

        uint256 token0Amount = token0.balanceOf(address(this)) * liquidity / totalSupply();
        uint256 token1Amount = token1.balanceOf(address(this)) * liquidity / totalSupply();

        _burn(msg.sender, liquidity);
        token0.transfer(msg.sender, token0Amount);
        token1.transfer(msg.sender, token1Amount);
    }

    /*//////////////////////////////////////////////////////////////
                                SWAP LOGIC
    //////////////////////////////////////////////////////////////*/


    /// @notice swap tokens
    /// @param token0In The amount of the first asset to swap in.
    /// @param token1In The amount of the second asset to swap in.
    /// @param token0OutMin The minimum amount of the first asset to swap out.
    /// @param token1OutMin The minimum amount of the second asset to swap out.
function swap(uint256 token0In, uint256 token1In, uint256 token0OutMin, uint256 token1OutMin) external {
    require(token0In > 0 || token1In > 0, "Invalid input amount");
    require(token0In == 0 || token1In == 0, "Only one token should be input");

    uint256 token0Out; // the amount of token0 to swap out
    uint256 token1Out; // the amount of token1 to swap out

    uint _fee; // the fee
    
    /// @dev swap token0 for token1
    /// @dev swap token1 for token0
    /// @dev the swap is done by calculating the output amount based on the input amount and the reserves of the two tokens in the pool

    // swap token0 for token1
    if (token0In > 0) {
        token0.transferFrom(msg.sender, address(this), token0In); // transfer token0 from sender to this contract
        token1Out = getOutputAmountWithFee(token0In, true); // calculate the output amount of token1 based on the input amount of token0
        require(token1Out >= token1OutMin, "Slippage protection"); // check if the output amount of token1 is greater than the minimum output amount of token1
        _fee = getOutputAmountNoFee(token0In,true) - token1Out; // calculate the fee
        token1.transfer(msg.sender, token1Out); // transfer token1 to sender
        token1.transfer(feeReceiver,_fee); // transfer fee to feeReceiver
        
    } else {
    // swap token1 for token0
        token1.transferFrom(msg.sender, address(this), token1In); // transfer token1 from sender to this contract
        token0Out = getOutputAmountWithFee(token1In,false); // calculate the output amount of token0 based on the input amount of token1
        require(token0Out >= token0OutMin, "Slippage protection"); // check if the output amount of token0 is greater than the minimum output amount of token0
        _fee = getOutputAmountNoFee(token1In,false) - token0Out; // calculate the fee
        token0.transfer(msg.sender, token0Out); // transfer token0 to sender
        token0.transfer(feeReceiver,_fee); // transfer fee to feeReceiver
    }

}

    /// @notice get the output amount without fee
    /// @param inputAmount The amount of the input token.
    /// @param isToken0 Whether the input token is token0.
    /// @dev The output amount is calculated based on the input amount and the reserves of the two tokens in the pool.
    function getOutputAmountNoFee(uint256 inputAmount, bool isToken0) public view returns (uint256) {
    uint256 token0Balance = token0.balanceOf(address(this));
    uint256 token1Balance = token1.balanceOf(address(this));

    uint256 numerator;
    uint256 denominator;
    if (isToken0) {
        numerator = inputAmount * token1Balance;
        denominator = token0Balance + inputAmount;
    } else {
        numerator = inputAmount * token0Balance;
        denominator = token1Balance + inputAmount;
    }

        return numerator / denominator;
    }

    /// @notice get the output amount with fee
    /// @param inputAmount The amount of the input token.
    /// @param isToken0 Whether the input token is token0.
    /// @dev The output amount is calculated based on the input amount and the reserves of the two tokens in the pool.
    function getOutputAmountWithFee(uint256 inputAmount, bool isToken0) public view returns (uint256) {
        uint256 token0Balance = token0.balanceOf(address(this));
        uint256 token1Balance = token1.balanceOf(address(this));

        uint256 inputAmountWithFee = inputAmount * 997;

        uint256 numerator;
        uint256 denominator;

        if (isToken0) {
            numerator = inputAmountWithFee * token1Balance;
            denominator = token0Balance * 1000 + inputAmountWithFee;
        } else {
            numerator = inputAmountWithFee * token0Balance;
            denominator = token1Balance * 1000 + inputAmountWithFee;
        }

        return numerator / denominator;
    }

    /*//////////////////////////////////////////////////////////////
                                UTILITIES
    //////////////////////////////////////////////////////////////*/


    /// @notice Returns the square root of a number.
    function sqrt(uint256 x) private pure returns (uint256) {
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    /// @notice Returns the minimum of two numbers.
    /// what is a minimum number? It is a number that is less than or equal to all other numbers. 
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }


    /*//////////////////////////////////////////////////////////////
                            FRONT END GETTERS
    /////////////////////////////////////////////////////////////*/

    function getToken0Balance() public view returns (uint256) {
        return IERC20(token0).balanceOf(address(this));
    }

    function getToken1Balance() public view returns (uint256) {
        return IERC20(token1).balanceOf(address(this));
    }

}
