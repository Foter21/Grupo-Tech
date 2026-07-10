function mostrarSenha() {
    const campoSenha = document.getElementById("senha");
    const iconeSenha = document.getElementById("iconeSenha");

    if (campoSenha.type === "password") {
        campoSenha.type = "text";
        iconeSenha.classList.remove("bi-eye");
        iconeSenha.classList.add("bi-eye-slash");
    } else {
        campoSenha.type = "password";
        iconeSenha.classList.remove("bi-eye-slash");
        iconeSenha.classList.add("bi-eye");
    }
}