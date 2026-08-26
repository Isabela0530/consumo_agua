let registros =
    JSON.parse(
        localStorage.getItem("registrosAgua")
    ) || [];


let grafico;


/*
    META DIÁRIA

    Recomendação:
    35 ml por kg corporal
*/

function calcularMeta(peso) {

    return 35 * peso;

}


/*
    PORCENTAGEM DA META
*/

function calcularPorcentagem(
    quantidade,
    peso
) {

    const meta = calcularMeta(peso);

    return (
        quantidade / meta
    ) * 100;

}


/*
    SALVAR
*/

function salvar() {

    localStorage.setItem(
        "registrosAgua",
        JSON.stringify(registros)
    );

}


/*
    DATA DE HOJE
*/

function obterDataHoje() {

    const hoje = new Date();

    const ano = hoje.getFullYear();

    const mes =
        String(
            hoje.getMonth() + 1
        ).padStart(2, "0");

    const dia =
        String(
            hoje.getDate()
        ).padStart(2, "0");

    return `${ano}-${mes}-${dia}`;

}


/*
    FORMATAR DATA
*/

function formatarData(data) {

    const partes =
        data.split("-");

    return (
        `${partes[2]}/` +
        `${partes[1]}/` +
        `${partes[0]}`
    );

}


/*
    FORMATAR ML
*/

function formatarMl(valor) {

    return valor.toLocaleString(
        "pt-BR"
    ) + " ml";

}


/*
    RENDERIZAR LISTA
*/

function renderizarRegistros() {

    const lista =
        document.getElementById(
            "listaRegistros"
        );


    const totalRegistros =
        document.getElementById(
            "totalRegistros"
        );


    lista.innerHTML = "";


    totalRegistros.textContent =
        registros.length === 1
            ? "1 registro"
            : `${registros.length} registros`;


    if (registros.length === 0) {

        lista.innerHTML = `
            <div class="sem-registros">

                <h3>
                    Nenhum consumo registrado
                </h3>

                <p>
                    Adicione seu primeiro registro acima.
                </p>

            </div>
        `;

        atualizarResumo();

        atualizarGrafico();

        return;

    }


    registros.forEach(registro => {

        const meta =
            calcularMeta(
                registro.peso
            );


        const porcentagem =
            calcularPorcentagem(
                registro.quantidade,
                registro.peso
            );


        const porcentagemVisual =
            Math.min(
                porcentagem,
                100
            );


        const item =
            document.createElement("div");


        item.className =
            "registro";


        item.onclick = () =>
            abrirModal(
                registro.id
            );


        item.innerHTML = `

            <div class="registro-topo">

                <div class="data">
                    📅 ${formatarData(
                        registro.data
                    )}
                </div>

                <button
                    class="btn-excluir"
                    onclick="
                        event.stopPropagation();
                        excluirRegistro(${registro.id})
                    "
                >
                    🗑️
                </button>

            </div>


            <div class="registro-info">

                <div class="info-item">

                    <span>
                        Consumo
                    </span>

                    <strong>
                        ${formatarMl(
                            registro.quantidade
                        )}
                    </strong>

                </div>


                <div class="info-item">

                    <span>
                        Peso
                    </span>

                    <strong>
                        ${registro.peso} kg
                    </strong>

                </div>


                <div class="info-item">

                    <span>
                        Meta diária
                    </span>

                    <strong>
                        ${formatarMl(
                            meta
                        )}
                    </strong>

                </div>

            </div>


            <div class="progresso">

                <div class="progresso-header">

                    <span>
                        Meta atingida
                    </span>

                    <strong>
                        ${porcentagem.toFixed(1)}%
                    </strong>

                </div>


                <div class="barra">

                    <div
                        class="barra-preenchida"
                        style="
                            width:
                            ${porcentagemVisual}%
                        "
                    ></div>

                </div>

            </div>

        `;


        lista.appendChild(item);

    });


    atualizarResumo();

    atualizarGrafico();

}


/*
    RESUMO DO DIA
*/

function atualizarResumo() {

    const hoje =
        obterDataHoje();


    const registrosHoje =
        registros.filter(
            registro =>
                registro.data === hoje
        );


    const total =
        registrosHoje.reduce(
            (
                soma,
                registro
            ) =>
                soma +
                registro.quantidade,

            0
        );


    let peso = 0;


    if (registrosHoje.length > 0) {

        peso =
            registrosHoje[
                registrosHoje.length - 1
            ].peso;

    }
    else if (registros.length > 0) {

        peso =
            registros[
                registros.length - 1
            ].peso;

    }


    const meta =
        peso > 0
            ? calcularMeta(peso)
            : 0;


    const porcentagem =
        meta > 0
            ? (total / meta) * 100
            : 0;


    document.getElementById(
        "totalHoje"
    ).textContent =
        formatarMl(total);


    document.getElementById(
        "metaHoje"
    ).textContent =
        formatarMl(meta);


    document.getElementById(
        "porcentagemHoje"
    ).textContent =
        porcentagem.toFixed(1) + "%";

}


/*
    ADICIONAR REGISTRO
*/

document
    .getElementById(
        "formAgua"
    )
    .addEventListener(
        "submit",
        function(event) {

            event.preventDefault();


            const registro = {

                id: Date.now(),

                data:
                    document.getElementById(
                        "data"
                    ).value,

                quantidade:
                    Number(
                        document.getElementById(
                            "quantidade"
                        ).value
                    ),

                peso:
                    Number(
                        document.getElementById(
                            "peso"
                        ).value
                    )

            };


            registros.push(
                registro
            );


            salvar();

            renderizarRegistros();


            this.reset();


            document.getElementById(
                "data"
            ).value =
                obterDataHoje();

        }
    );


/*
    EXCLUIR
*/

function excluirRegistro(id) {

    registros =
        registros.filter(
            registro =>
                registro.id !== id
        );


    salvar();

    renderizarRegistros();

}


/*
    LIMPAR TUDO
*/

function limparTudo() {

    if (registros.length === 0) {
        return;
    }


    const confirmar =
        confirm(
            "Deseja realmente excluir todos os registros?"
        );


    if (!confirmar) {
        return;
    }


    registros = [];

    salvar();

    renderizarRegistros();

}


/*
    ABRIR MODAL
*/

function abrirModal(id) {

    const registro =
        registros.find(
            item =>
                item.id === id
        );


    if (!registro) {
        return;
    }


    document.getElementById(
        "editarId"
    ).value =
        registro.id;


    document.getElementById(
        "editarData"
    ).value =
        registro.data;


    document.getElementById(
        "editarQuantidade"
    ).value =
        registro.quantidade;


    document.getElementById(
        "editarPeso"
    ).value =
        registro.peso;


    document.getElementById(
        "modal"
    ).classList.add(
        "ativo"
    );

}


/*
    FECHAR MODAL
*/

function fecharModal() {

    document.getElementById(
        "modal"
    ).classList.remove(
        "ativo"
    );

}


/*
    EDITAR
*/

document
    .getElementById(
        "formEditar"
    )
    .addEventListener(
        "submit",
        function(event) {

            event.preventDefault();


            const id =
                Number(
                    document.getElementById(
                        "editarId"
                    ).value
                );


            const registro =
                registros.find(
                    item =>
                        item.id === id
                );


            if (!registro) {
                return;
            }


            registro.data =
                document.getElementById(
                    "editarData"
                ).value;


            registro.quantidade =
                Number(
                    document.getElementById(
                        "editarQuantidade"
                    ).value
                );


            registro.peso =
                Number(
                    document.getElementById(
                        "editarPeso"
                    ).value
                );


            salvar();

            renderizarRegistros();

            fecharModal();

        }
    );


/*
    GRÁFICO
*/

function atualizarGrafico() {

    const canvas =
        document.getElementById(
            "graficoAgua"
        );


    const labels =
        registros.map(
            registro =>
                formatarData(
                    registro.data
                )
        );


    const consumos =
        registros.map(
            registro =>
                registro.quantidade
        );


    const metas =
        registros.map(
            registro =>
                calcularMeta(
                    registro.peso
                )
        );


    if (grafico) {

        grafico.destroy();

    }


    grafico =
        new Chart(
            canvas,
            {

                type: "bar",

                data: {

                    labels: labels,

                    datasets: [

                        {

                            label:
                                "Consumo (ml)",

                            data:
                                consumos,

                            borderWidth: 1

                        },

                        {

                            label:
                                "Meta diária (ml)",

                            data:
                                metas,

                            borderWidth: 1

                        }

                    ]

                },


                options: {

                    responsive: true,

                    maintainAspectRatio:
                        false,

                    scales: {

                        y: {

                            beginAtZero:
                                true,

                            title: {

                                display:
                                    true,

                                text:
                                    "Quantidade (ml)"

                            }

                        }

                    }

                }

            }
        );

}


/*
    TEMA
*/

function alternarTema() {

    document.body.classList.toggle(
        "escuro"
    );


    const escuro =
        document.body.classList.contains(
            "escuro"
        );


    document.getElementById(
        "btnTema"
    ).textContent =
        escuro
            ? "☀️"
            : "🌙";


    localStorage.setItem(
        "temaAgua",
        escuro
            ? "escuro"
            : "claro"
    );

}


/*
    CARREGAR TEMA
*/

function carregarTema() {

    const tema =
        localStorage.getItem(
            "temaAgua"
        );


    if (tema === "escuro") {

        document.body.classList.add(
            "escuro"
        );


        document.getElementById(
            "btnTema"
        ).textContent =
            "☀️";

    }

}


/*
    INICIALIZAÇÃO
*/

document.getElementById(
    "data"
).value =
    obterDataHoje();


carregarTema();

renderizarRegistros();