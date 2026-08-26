let caminhadas = JSON.parse(localStorage.getItem("caminhadas")) || [];

let grafico;


// CALCULAR CALORIAS
function calcularCalorias(peso, distancia) {
    return 0.7 * peso * distancia;
}


// SALVAR NO LOCAL STORAGE
function salvar() {
    localStorage.setItem("caminhadas", JSON.stringify(caminhadas));
}


// MOSTRAR CAMINHADAS
function renderizarCaminhadas() {

    const lista = document.getElementById("listaCaminhadas");
    const total = document.getElementById("totalCaminhadas");

    lista.innerHTML = "";

    total.textContent =
        caminhadas.length === 1
            ? "1 caminhada registrada"
            : `${caminhadas.length} caminhadas registradas`;


    if (caminhadas.length === 0) {

        lista.innerHTML = `
            <div class="sem-registros">
                <h3>Nenhuma caminhada registrada</h3>
                <p>Adicione sua primeira caminhada acima.</p>
            </div>
        `;

        atualizarGrafico();
        return;
    }


    caminhadas.forEach(caminhada => {

        const calorias = calcularCalorias(
            caminhada.peso,
            caminhada.distancia
        );

        const item = document.createElement("div");

        item.className = "caminhada";

        item.onclick = () => abrirModal(caminhada.id);

        item.innerHTML = `
            <div class="info-caminhada">

                <div class="rota">
                    📍 ${caminhada.partida}
                    → ${caminhada.chegada}
                </div>

                <div class="detalhes">
                    📅 ${formatarData(caminhada.data)}
                    • ${caminhada.distancia} km
                    • ${caminhada.peso} kg
                </div>

            </div>

            <div class="acoes">

                <div class="calorias">
                    ${calorias.toFixed(1)} kcal
                </div>

                <button
                    class="btn-excluir"
                    onclick="event.stopPropagation(); excluirCaminhada(${caminhada.id})"
                >
                    🗑️
                </button>

            </div>
        `;

        lista.appendChild(item);

    });

    atualizarGrafico();
}


// FORMATAR DATA
function formatarData(data) {

    const partes = data.split("-");

    return `${partes[2]}/${partes[1]}/${partes[0]}`;
}


// ADICIONAR CAMINHADA
document
    .getElementById("formCaminhada")
    .addEventListener("submit", function(event) {

        event.preventDefault();

        const novaCaminhada = {

            id: Date.now(),

            data: document.getElementById("data").value,

            partida: document
                .getElementById("partida")
                .value,

            chegada: document
                .getElementById("chegada")
                .value,

            distancia: Number(
                document.getElementById("distancia").value
            ),

            peso: Number(
                document.getElementById("peso").value
            )

        };


        caminhadas.push(novaCaminhada);

        salvar();

        renderizarCaminhadas();

        this.reset();

    });


// EXCLUIR
function excluirCaminhada(id) {

    caminhadas = caminhadas.filter(
        caminhada => caminhada.id !== id
    );

    salvar();

    renderizarCaminhadas();
}


// LIMPAR TUDO
function limparTudo() {

    if (caminhadas.length === 0) {
        return;
    }

    const confirmar = confirm(
        "Deseja realmente excluir todas as caminhadas?"
    );

    if (!confirmar) {
        return;
    }

    caminhadas = [];

    salvar();

    renderizarCaminhadas();
}


// ABRIR MODAL
function abrirModal(id) {

    const caminhada = caminhadas.find(
        item => item.id === id
    );

    if (!caminhada) {
        return;
    }


    document.getElementById("editarId").value = caminhada.id;

    document.getElementById("editarData").value =
        caminhada.data;

    document.getElementById("editarPartida").value =
        caminhada.partida;

    document.getElementById("editarChegada").value =
        caminhada.chegada;

    document.getElementById("editarDistancia").value =
        caminhada.distancia;

    document.getElementById("editarPeso").value =
        caminhada.peso;


    document
        .getElementById("modal")
        .classList.add("ativo");
}


// FECHAR MODAL
function fecharModal() {

    document
        .getElementById("modal")
        .classList.remove("ativo");
}


// EDITAR CAMINHADA
document
    .getElementById("formEditar")
    .addEventListener("submit", function(event) {

        event.preventDefault();

        const id = Number(
            document.getElementById("editarId").value
        );

        const caminhada = caminhadas.find(
            item => item.id === id
        );

        if (!caminhada) {
            return;
        }


        caminhada.data =
            document.getElementById("editarData").value;

        caminhada.partida =
            document.getElementById("editarPartida").value;

        caminhada.chegada =
            document.getElementById("editarChegada").value;

        caminhada.distancia =
            Number(
                document.getElementById("editarDistancia").value
            );

        caminhada.peso =
            Number(
                document.getElementById("editarPeso").value
            );


        salvar();

        renderizarCaminhadas();

        fecharModal();

    });


// GRÁFICO
function atualizarGrafico() {

    const canvas =
        document.getElementById("graficoCalorias");

    const labels = caminhadas.map(
        (caminhada, index) =>
            `Caminhada ${index + 1}`
    );

    const valores = caminhadas.map(
        caminhada =>
            calcularCalorias(
                caminhada.peso,
                caminhada.distancia
            )
    );


    if (grafico) {
        grafico.destroy();
    }


    grafico = new Chart(canvas, {

        type: "bar",

        data: {

            labels: labels,

            datasets: [

                {
                    label: "Calorias gastas (kcal)",

                    data: valores,

                    borderWidth: 1

                }

            ]

        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            scales: {

                y: {

                    beginAtZero: true,

                    title: {

                        display: true,

                        text: "Calorias (kcal)"

                    }

                }

            }

        }

    });

}


// TEMA
function alternarTema() {

    document.body.classList.toggle("escuro");

    const escuro =
        document.body.classList.contains("escuro");

    document.getElementById("btnTema").textContent =
        escuro ? "☀️" : "🌙";

    localStorage.setItem(
        "tema",
        escuro ? "escuro" : "claro"
    );
}


// CARREGAR TEMA
function carregarTema() {

    const tema =
        localStorage.getItem("tema");

    if (tema === "escuro") {

        document.body.classList.add("escuro");

        document.getElementById("btnTema").textContent =
            "☀️";
    }
}


// INICIALIZAÇÃO
carregarTema();

renderizarCaminhadas();