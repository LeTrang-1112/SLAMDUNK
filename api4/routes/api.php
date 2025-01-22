<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\DonHangController;
use App\Http\Controllers\NguoiDungController;
use App\Http\Controllers\DanhGiaController;
use App\Http\Controllers\AminController;
use App\Http\Controllers\ThuongHieuController;

//Hiển thị sản phẩm ở trang chính
Route::get('/products', [ProductController::class, 'ThongTinSanPham']);
//Hiển thị thông tin chi tiết sản phẩm
Route::get('/product/{id}', [ProductController::class, 'ChiTietSanPham']);
//Thêm sản phẩm vào giỏ hàng
Route::post('/cart', [DonHangController::class, 'addToCart']);
//Hiển thị thông tin sản phẩm trong giỏ hàng
Route::get('/showCart', [DonHangController::class, 'showCart']);
//Xóa tất cả sản phẩm trong giỏ hàng
Route::delete('/deletecart', [DonHangController::class, 'removeCartItems']);
Route::post('/countCart', [DonHangController::class, 'getCartItemCount']);


//Xóa danh sách sản phẩm trong giỏ hàng
Route::delete('/listdeletecart', [DonHangController::class, 'removeCartItem']);
//Cập nhật giỏ hàng
Route::post('/cart/updatequantity', [DonHangController::class, 'updateCartItemQuantity']);
//Chuyển dữ liệu qua trang thanh toán
Route::post('/showPayment', [DonHangController::class, 'showPaymentInfo']);
//Đặt hàng
Route::post('/oder', [DonHangController::class, 'placeOrder']);
//Xem lịch sử mua hàng
Route::get('/orders/{nguoiDungId}', [DonHangController::class, 'getOrdersByUser']);
//Hủy đơn hàng
Route::delete('/orders/{donHangId}/cancel', [DonHangController::class, 'cancelOrder']);

//Xem danh sách người dùng
Route::get('/nguoidung', [NguoiDungController::class, 'index']);
//Đăng ký
Route::post('/nguoidung/register', [NguoiDungController::class, 'register']);
//Đăng nhập
Route::post('/nguoidung/login', [NguoiDungController::class, 'login']);
//Cập nhật thông tin
Route::put('/nguoidung/{id}', [NguoiDungController::class, 'update']);
//hiển thị thông tin
Route::get('/nguoidung/{id}', [NguoiDungController::class, 'show']);
Route::get('/admin/{id}', [NguoiDungController::class, 'showAdmin']);

Route::post('/change-password', [NguoiDungController::class, 'thaydoimatkhau']);
Route::post('/reset-password', [NguoiDungController::class, 'resetPassword']);
Route::post('cart/create', [NguoiDungController::class, 'createCartForUser']);
Route::prefix('danhgia')->group(function () {
    // api.php
    Route::get('/{id}', [DanhGiaController::class, 'getDanhGiaBySanPham']);

    Route::get('/', [DanhGiaController::class, 'index']); // Hiển thị danh sách đánh giá
    Route::put('/{id}', [DanhGiaController::class, 'update']); // Cập nhật đánh giá
    Route::delete('/{id}', [DanhGiaController::class, 'destroy']); // Xóa đánh giá
});
Route::post('/danhgia', [DanhGiaController::class, 'store']); // Thêm mới đánh giá
Route::get('/danhgiashow/{ctdhId}', [DanhGiaController::class, 'getDanhGiaByCTDH']);
Route::get('/danhgiasp/{spid}', [DanhGiaController::class, 'getDanhGiaBySanPham']);


Route::prefix('donhang')->group(function () {
    Route::get('/soluongban', [AminController::class, 'totalSold']);
    Route::get('/status/{status}', [AminController::class, 'getByStatus']);

    Route::get('/', [AminController::class, 'index']); // Hiển thị danh sách đơn hàng
    Route::get('/{id}', [AminController::class, 'show']); // Hiển thị chi tiết đơn hàng
    Route::put('/{id}/status', [AminController::class, 'updateStatus']); // Cập nhật trạng thái đơn hàng
});


Route::get('/thuong-hieu', [ThuongHieuController::class, 'index']);
Route::get('/thuong-hieu/{id}', [ThuongHieuController::class, 'show']);
Route::post('/thuong-hieu', [ThuongHieuController::class, 'store']);
Route::put('/thuong-hieu/{id}', [ThuongHieuController::class, 'update']);
Route::delete('/thuong-hieu/{id}', [ThuongHieuController::class, 'destroy']);
