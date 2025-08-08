$(document).ready(function () {
    const apiBaseUrl = window.location.origin + "/api/products";
    let allProducts = [];

    function showLoading() {
        $("#loading").show();
        $("#products-container").hide();
    }

    function hideLoading() {
        $("#loading").hide();
        $("#products-container").show();
    }

    function showError(message) {
        alert("Error: " + message);
    }

    function showSuccess(message) {
        // Remover alertas existentes
        $(".alert").remove();
        
        const alertHtml = `
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="display: none;">
                <i class="fas fa-check-circle me-2"></i>
                <strong>¡Éxito!</strong> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        $("#products-container").prepend(alertHtml);
        
        // Animación suave de entrada
        $(".alert").slideDown(400);
        
        setTimeout(function() {
            $(".alert").slideUp(400, function() {
                $(this).remove();
            });
        }, 4000);
    }

    function loadProducts() {
        showLoading();
        
        $.get(apiBaseUrl)
            .done(function (data) {
                allProducts = data;
                displayProducts(allProducts);
                hideLoading();
            })
            .fail(function (xhr, status, error) {
                hideLoading();
                showError("No se pudieron cargar los productos. " + error);
            });
    }

    function displayProducts(products) {
        const productsList = $("#products-list");
        productsList.empty();

        if (!products || products.length === 0) {
            productsList.append(`
                <div class="col-12">
                    <div class="alert alert-info text-center">
                        <h4>No hay productos disponibles</h4>
                        <p>Comienza agregando tu primer producto deportivo.</p>
                    </div>
                </div>
            `);
            return;
        }

        products.forEach(function (product) {
            const categoryColors = {
                "Futbol": "success",
                "Basquetbol": "warning",
                "Natacion": "info", 
                "Tenis": "danger"
            };
            
            const cardColor = categoryColors[product.Category] || "secondary";
            
            const productCard = `
                <div class="col-md-6 col-lg-4 mb-3">
                    <div class="card h-100">
                        <div class="card-header bg-${cardColor} text-white">
                            <h5 class="card-title mb-0">${product.Name}</h5>
                        </div>
                        <div class="card-body">
                            <p class="card-text">${product.Description || "Sin descripcion"}</p>
                            <p class="card-text">
                                <strong>Precio:</strong> $${product.Price.toFixed(2)}<br>
                                <strong>Stock:</strong> ${product.Stock} unidades<br>
                                <strong>Categoria:</strong> <span class="badge bg-${cardColor}">${product.Category}</span>
                            </p>
                        </div>
                        <div class="card-footer">
                            <div class="btn-group w-100" role="group">
                                <button class="btn btn-outline-primary btn-sm" onclick="viewProductDetails(${product.IdProduct})">
                                    <i class="fas fa-eye"></i> Ver
                                </button>
                                <button class="btn btn-outline-warning btn-sm" onclick="editProduct(${product.IdProduct})">
                                    <i class="fas fa-edit"></i> Editar
                                </button>
                                <button class="btn btn-outline-danger btn-sm" onclick="confirmDeleteProduct(${product.IdProduct}, '${product.Name}')">
                                    <i class="fas fa-trash"></i> Eliminar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            productsList.append(productCard);
        });
    }

    function filterProducts() {
        const selectedCategory = $("#categoryFilter").val();
        
        if (!selectedCategory) {
            displayProducts(allProducts);
        } else {
            const filteredProducts = allProducts.filter(p => p.Category === selectedCategory);
            displayProducts(filteredProducts);
        }
    }

    window.openCreateModal = function() {
        $("#modalTitle").text("Nuevo Producto");
        $("#productForm")[0].reset();
        $("#productId").val("0");
        clearValidationErrors();
    };

    window.editProduct = function(id) {
        const product = allProducts.find(p => p.IdProduct === id);
        if (!product) {
            showError("Producto no encontrado");
            return;
        }

        $("#modalTitle").text("Editar Producto");
        $("#productId").val(product.IdProduct);
        $("#productName").val(product.Name);
        $("#productDescription").val(product.Description);
        $("#productPrice").val(product.Price);
        $("#productStock").val(product.Stock);
        $("#productCategory").val(product.Category);
        
        clearValidationErrors();
        $("#productModal").modal("show");
    };

    window.viewProductDetails = function(id) {
        showLoading();
        
        $.get(`${apiBaseUrl}/${id}`)
            .done(function (product) {
                hideLoading();
                const detailsHtml = `
                    <div class="row">
                        <div class="col-sm-4"><strong>ID:</strong></div>
                        <div class="col-sm-8">${product.IdProduct}</div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-sm-4"><strong>Nombre:</strong></div>
                        <div class="col-sm-8">${product.Name}</div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-sm-4"><strong>Descripcion:</strong></div>
                        <div class="col-sm-8">${product.Description || "Sin descripcion"}</div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-sm-4"><strong>Precio:</strong></div>
                        <div class="col-sm-8">$${product.Price.toFixed(2)}</div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-sm-4"><strong>Stock:</strong></div>
                        <div class="col-sm-8">${product.Stock} unidades</div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-sm-4"><strong>Categoria:</strong></div>
                        <div class="col-sm-8"><span class="badge bg-primary">${product.Category}</span></div>
                    </div>
                `;
                $("#productDetails").html(detailsHtml);
                $("#detailsModal").modal("show");
            })
            .fail(function (xhr, status, error) {
                hideLoading();
                showError("No se pudieron cargar los detalles del producto");
            });
    };

    window.confirmDeleteProduct = function(id, name) {
        if (confirm(`Esta seguro que desea eliminar el producto "${name}"?`)) {
            deleteProduct(id);
        }
    };

    function deleteProduct(id) {
        showLoading();
        
        $.ajax({
            url: `${apiBaseUrl}/${id}`,
            type: "DELETE",
            success: function () {
                hideLoading();
                showSuccess("Producto eliminado correctamente");
                loadProducts();
            },
            error: function (xhr, status, error) {
                hideLoading();
                showError("No se pudo eliminar el producto. " + error);
            }
        });
    }

    window.saveProduct = function() {
        if (!validateForm()) {
            return;
        }

        const productData = {
            IdProduct: parseInt($("#productId").val()) || 0,
            Name: $("#productName").val().trim(),
            Description: $("#productDescription").val().trim(),
            Price: parseFloat($("#productPrice").val()),
            Stock: parseInt($("#productStock").val()),
            Category: $("#productCategory").val()
        };

        const isEditing = productData.IdProduct > 0;
        const url = isEditing ? `${apiBaseUrl}/${productData.IdProduct}` : apiBaseUrl;
        const method = isEditing ? "PUT" : "POST";

        $("#saveProductBtn").prop("disabled", true).text("Guardando...");

        $.ajax({
            url: url,
            type: method,
            contentType: "application/json",
            data: JSON.stringify(productData),
            success: function () {
                $("#productModal").modal("hide");
                showSuccess(isEditing ? "Producto actualizado correctamente" : "Producto creado correctamente");
                loadProducts();
            },
            error: function (xhr, status, error) {
                let errorMessage = "Error al guardar el producto";
                
                if (xhr.responseJSON && xhr.responseJSON.Message) {
                    errorMessage = xhr.responseJSON.Message;
                } else if (xhr.responseText) {
                    errorMessage = xhr.responseText;
                }
                
                showError(errorMessage);
            },
            complete: function () {
                $("#saveProductBtn").prop("disabled", false).text("Guardar");
            }
        });
    };

    function validateForm() {
        let isValid = true;
        clearValidationErrors();

        const name = $("#productName").val().trim();
        const price = parseFloat($("#productPrice").val());
        const stock = parseInt($("#productStock").val());
        const category = $("#productCategory").val();

        if (!name) {
            showFieldError("productName", "El nombre es requerido");
            isValid = false;
        }

        if (!price || price <= 0) {
            showFieldError("productPrice", "El precio debe ser mayor a 0");
            isValid = false;
        }

        if (isNaN(stock) || stock < 0) {
            showFieldError("productStock", "El stock no puede ser negativo");
            isValid = false;
        }

        if (!category) {
            showFieldError("productCategory", "La categoria es requerida");
            isValid = false;
        }

        return isValid;
    }

    function showFieldError(fieldId, message) {
        const field = $("#" + fieldId);
        field.addClass("is-invalid");
        field.next(".invalid-feedback").text(message);
    }

    function clearValidationErrors() {
        $(".form-control, .form-select").removeClass("is-invalid");
        $(".invalid-feedback").text("");
    }

    $("#categoryFilter").change(filterProducts);

    // Validaciones en tiempo real mejoradas
    $("#productName").on("input blur", function() {
        const value = $(this).val().trim();
        if (!value) {
            showFieldError("productName", "El nombre es requerido");
        } else {
            $(this).removeClass("is-invalid");
        }
    });

    $("#productPrice").on("input blur", function() {
        const value = parseFloat($(this).val());
        if (isNaN(value) || value <= 0) {
            showFieldError("productPrice", "El precio debe ser mayor a 0");
        } else {
            $(this).removeClass("is-invalid");
        }
    });

    $("#productStock").on("input blur", function() {
        const value = parseInt($(this).val());
        if (isNaN(value) || value < 0) {
            showFieldError("productStock", "El stock no puede ser negativo");
        } else {
            $(this).removeClass("is-invalid");
        }
    });

    $("#productCategory").on("change", function() {
        const value = $(this).val();
        if (!value) {
            showFieldError("productCategory", "La categoria es requerida");
        } else {
            $(this).removeClass("is-invalid");
        }
    });

    // Limpiar errores al escribir
    $("#productForm input, #productForm select, #productForm textarea").on("input change", function() {
        if ($(this).hasClass("is-valid") || $(this).val().trim() !== "") {
            $(this).removeClass("is-invalid");
            $(this).next(".invalid-feedback").text("");
        }
    });

    loadProducts();

    // Pequeño delay para asegurar que el DOM está listo
    setTimeout(function () {
        loadProducts();
    }, 500);
});
