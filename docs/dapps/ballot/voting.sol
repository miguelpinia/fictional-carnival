pragma solidity ^0.4.18;
// Hay que especificar la versión del compilar que se está utilizando.

contract Voting {

    /*
     * Campo que que es equivalente a un diccionario o un arreglo
     * asociativo. La llave de la estructura es el nombre del
     * candidato almacendo como un arreglo de 32 bytes (bytes32) y el
     * valor es un entero sin signo que almacena cuando votos tiene.
     */
    mapping (bytes32 => uint8) public votesReceived;

    /**
     * Solidity no permite pasar un arreglo de cadenas en el
     * constructor que (aún).  Vamos a utilizar un arreglo de 32 bits
     * para almacenar la lista de candidatos.
     */
    bytes32[] public candidateList;

    /*
     * Constructor que es invocado cuando se despliega el contrato a
     * la blockchain. Cuando deplegamos el contrato, pasamos un
     * arreglo con los nombres de los candidatos que van a participar
     * en la eleccíon.
     */
    function Voting(bytes32[] candidateNames) public {
        candidateList = candidateNames;
    }

    /*
     * Cuenta el total de votos que un candidato ha
     * recibido. Previamente valida que el candidato se ecuentre
     * registrado.
     */
    function totalVotesFor(bytes32 candidate) view public returns (uint8) {
        require(validCandidate(candidate));
        return votesReceived[candidate];
    }

    /*
     * Esta función incremente el contador de votos para un candidato
     * específico. Igual tiene que validar que el candidato se
     * encuentre registrado antes de incrementar su cantidad de votos.
     */
    function voteForCandidate(bytes32 candidate) public {
        require(validCandidate(candidate));
        votesReceived[candidate] += 1;
    }

    /*
     * Valida el candidato
     */
    function validCandidate(bytes32 candidate) view public returns (bool) {
        for(uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }
        return false;
    }
}
