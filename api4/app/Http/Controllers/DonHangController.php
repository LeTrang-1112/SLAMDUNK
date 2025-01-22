<?php

namespace App\Http\Controllers;

use App\Models\SanPham;
use App\Models\GioHang;
use App\Models\ChiTietGioHang;
use App\Models\DonHang;
use App\Models\ChiTietDonHang;

use Illuminate\Http\Request;
use Carbon\Carbon;

class DonHangController extends Controller
{
    public function addToCart(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'SanPhamId' => 'required|exists:SanPham,SanPhamId',
                'SoLuong' => 'required|integer|min:1',
                'NguoiDungId' => 'required|exists:GioHang,NguoiDungId',
            ]);
    
            $sanPhamId = $validatedData['SanPhamId'];
            $soLuong = $validatedData['SoLuong'];
            $nguoiDungId = $validatedData['NguoiDungId'];
    
            $sanPham = SanPham::find($sanPhamId);
            if (!$sanPham) {
                return response()->json([
                    'error' => 'Sản phẩm không tồn tại',
                ], 404);
            }
    
            if ($sanPham->SoLuongTon < $soLuong) {
                return response()->json([
                    'error' => 'Số lượng sản phẩm trong kho không đủ',
                ], 400);
            }
    
            $gioHang = GioHang::firstOrCreate(['NguoiDungId' => $nguoiDungId], ['TongTien' => 0]);
    
            $chiTietGioHang = ChiTietGioHang::firstOrNew(
                ['GioHangId' => $gioHang->GioHangId, 'SanPhamId' => $sanPhamId]
            );
    
            $tongSoLuong = $chiTietGioHang->SoLuong + $soLuong;
            if ($sanPham->SoLuongTon < $tongSoLuong) {
                return response()->json([
                    'error' => 'Số lượng sản phẩm trong kho không đủ',
                ], 400);
            }
    
            $chiTietGioHang->SoLuong += $soLuong;
            $chiTietGioHang->Gia = $chiTietGioHang->SoLuong * $sanPham->Gia;
            $chiTietGioHang->save();
    
            $gioHang->TongTien = ChiTietGioHang::where('GioHangId', $gioHang->GioHangId)->sum('Gia');
            $gioHang->save();
    
            $sanPham->SoLuongTon -= $soLuong;
            $sanPham->save();
    
            return response()->json([
                'message' => 'Sản phẩm đã được thêm vào giỏ hàng',
                'cart' => $gioHang,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Đã xảy ra lỗi, vui lòng thử lại sau',
                'details' => $e->getMessage(),
            ], 500);
        }
    }
    public function showCart(Request $request)
    {
        $nguoiDungId = $request->input('NguoiDungId');

        $gioHang = GioHang::where('NguoiDungId', $nguoiDungId)->first();

        if (!$gioHang) {
            return response()->json([
                'message' => 'Giỏ hàng của bạn hiện đang trống.',
                'cart' => null,
            ]);
        }

        $items = ChiTietGioHang::where('ChiTietGioHang.GioHangId', $gioHang->GioHangId)
    ->join('SanPham', 'ChiTietGioHang.SanPhamId', '=', 'SanPham.SanPhamId')
    ->leftJoin('HinhAnhSanPham', 'SanPham.SanPhamId', '=', 'HinhAnhSanPham.SanPhamId')
    ->select(
        'ChiTietGioHang.CTGHId as cart_item_id',
        'SanPham.SanPhamId as product_id',
        'SanPham.TenSanPham as name',
        \DB::raw('MIN(HinhAnhSanPham.DuongDan) as image'), // Lấy hình ảnh đầu tiên
        'SanPham.Gia as price',
        'ChiTietGioHang.SoLuong as quantity'
    )
    ->groupBy('ChiTietGioHang.CTGHId', 'SanPham.SanPhamId', 'SanPham.TenSanPham', 'SanPham.Gia', 'ChiTietGioHang.SoLuong')
    ->get();


        return response()->json([
            'cart_id' => $gioHang->GioHangId,
            'total_price' => $gioHang->TongTien,
            'items' => $items,
        ]);
    }
    //XÓA SẢN PHẨM KHỎI GIỎ HÀNG
    public function removeCartItems(Request $request)
    {
        $nguoiDungId = $request->input('NguoiDungId');
        $cartItemId = $request->input('GioHangId');

        $gioHang = GioHang::where('NguoiDungId', $nguoiDungId)->first();
        if (!$gioHang) {
            return response()->json([
                'message' => 'Giỏ hàng của bạn hiện đang trống.',
            ], 404);
        }

        $cartItem = ChiTietGioHang::where('GioHangId', $gioHang->GioHangId)
            ->where('CTGHId', $cartItemId)
            ->first();

        if (!$cartItem) {
            return response()->json([
                'message' => 'Mục giỏ hàng không tồn tại.',
            ], 404);
        }

        $cartItem->delete();

        return response()->json([
            'message' => 'Sản phẩm đã được xóa khỏi giỏ hàng thành công.',
        ]);
    }
    public function removeCartItem(Request $request)
    {
        $nguoiDungId = $request->input('NguoiDungId');
        $ctghIds = $request->input('CTGHIds'); 

        if (empty($ctghIds) || !is_array($ctghIds)) {
            return response()->json([
                'error' => 'Danh sách sản phẩm cần xóa không hợp lệ.',
            ], 400);
        }

        $gioHang = GioHang::where('NguoiDungId', $nguoiDungId)->first();
        if (!$gioHang) {
            return response()->json([
                'error' => 'Giỏ hàng của bạn hiện đang trống.',
            ], 404);
        }

        $deletedItems = ChiTietGioHang::where('GioHangId', $gioHang->GioHangId)
            ->whereIn('CTGHId', $ctghIds) 
            ->delete();

        if ($deletedItems === 0) {
            return response()->json([
                'error' => 'Không có sản phẩm nào được tìm thấy trong giỏ hàng.',
            ], 404);
        }

        return response()->json([
            'message' => 'Sản phẩm đã được xóa khỏi giỏ hàng thành công.',
            'deleted_count' => $deletedItems, 
        ]);
    }

    public function showPaymentInfo(Request $request)
    {
        try {
            $nguoiDungId = $request->input('NguoiDungId');
            $sanPhamList = $request->input('sanPhamList');
            $diaChiGiaoHang = $request->input('diachi');
            $soDienThoai = $request->input('SoDienThoai');
            $nguoinhan = $request->input('nguoinhan');
            if (empty($sanPhamList)) {
                return response()->json([
                    'message' => 'Danh sách sản phẩm không được để trống.',
                ], 400);
            }

            $nguoiDung = GioHang::where('GioHang.NguoiDungId', $nguoiDungId)  
            ->join('NguoiDung', 'GioHang.NguoiDungId', '=', 'NguoiDung.NguoiDungId')
            ->select('NguoiDung.TenNguoiDung', 'NguoiDung.DiaChi', 'NguoiDung.SoDienThoai')
            ->first();
        

            if (!$nguoiDung) {
                return response()->json([
                    'message' => 'Thông tin người dùng không tồn tại.',
                ], 404);
            }

            $totalPrice = 0;
            $items = [];

            foreach ($sanPhamList as $sanPhamData) {
                $sanPhamId = $sanPhamData['SanPhamId'];
                $soLuong = $sanPhamData['SoLuong'];

                $sanPham = SanPham::find($sanPhamId);
                if (!$sanPham) {
                    return response()->json([
                        'message' => 'Sản phẩm với ID ' . $sanPhamId . ' không tồn tại.',
                    ], 404);
                }

                if ($sanPham->SoLuongTon < $soLuong) {
                    return response()->json([
                        'message' => 'Sản phẩm ' . $sanPham->TenSanPham . ' không đủ số lượng trong kho.',
                    ], 400);
                }

                $gia = $sanPham->Gia * $soLuong;
                $totalPrice += $gia;

                $items[] = [
                    'product_id' => $sanPhamId,
                    'name' => $sanPham->TenSanPham,
                    'price' => $sanPham->Gia,
                    'quantity' => $soLuong,
                    'total_price' => $gia,
                    'description' => $sanPham->MoTa,
                    'image' => $sanPham->HinhAnh,
                ];
            }

            return response()->json([
                'user' => [
                    'name' => $nguoiDung->TenNguoiDung,
                    'address' => $nguoiDung->DiaChi,
                    'phone' => $nguoiDung->SoDienThoai,
                ],
                'order' => [
                    'total_price' => $totalPrice,
                    'items' => $items,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Đã có lỗi xảy ra.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    public function placeOrder(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'NguoiDungId' => 'required|integer',
                'sanPhamList' => 'required|array',
                'sanPhamList.*.SanPhamId' => 'required|integer',
                'sanPhamList.*.SoLuong' => 'required|integer',
                'PhuongThucThanhToan' => 'required|string',
                'DiaChiGiaoHang' => 'required|string',
                'GhiChu' => 'nullable|string',
                'SoDienThoai' => 'required|string',
                'NguoiNhan' => 'required|string'
            ]);

            $nguoiDungId = $validatedData['NguoiDungId'];
            $sanPhamList = $validatedData['sanPhamList'];
            $phuongThucThanhToan = $validatedData['PhuongThucThanhToan'];
            $diaChiGiaoHang = $validatedData['DiaChiGiaoHang'];
            $ghiChu = $validatedData['GhiChu'];
            $soDienThoai =(string)$validatedData['SoDienThoai'];
            $nguoinhan = $validatedData['NguoiNhan'];

            $nguoiDung = GioHang::where('GioHang.NguoiDungId', $nguoiDungId)
                ->join('NguoiDung', 'GioHang.NguoiDungId', '=', 'NguoiDung.NguoiDungId')
                ->select('NguoiDung.TenNguoiDung', 'NguoiDung.DiaChi', 'NguoiDung.SoDienThoai')
                ->first();

            if (!$nguoiDung) {
                return response()->json([
                    'message' => 'Thông tin người dùng không tồn tại.',
                ], 404);
            }

            $totalPrice = 0;
            $items = [];

            foreach ($sanPhamList as $sanPhamData) {
                $sanPhamId = $sanPhamData['SanPhamId'];
                $soLuong = $sanPhamData['SoLuong'];

                $sanPham = SanPham::find($sanPhamId);
                if (!$sanPham) {
                    return response()->json([
                        'message' => 'Sản phẩm với ID ' . $sanPhamId . ' không tồn tại.',
                    ], 404);
                }

                if ($sanPham->SoLuongTon < $soLuong) {
                    return response()->json([
                        'message' => 'Sản phẩm ' . $sanPham->TenSanPham . ' không đủ số lượng trong kho.',
                    ], 400);
                }

                $gia = $sanPham->Gia * $soLuong;
                $totalPrice += $gia;

                $items[] = [
                    'SanPhamId' => $sanPhamId,
                    'SoLuong' => $soLuong,
                    'Gia' => $sanPham->Gia,
                    'TotalPrice' => $gia,
                ];
            }

            $donHang = DonHang::create([
                'NguoiDungId' => $nguoiDungId,
                'TongTien' => $totalPrice,
                'PhuongThucThanhToan' => $phuongThucThanhToan,
                'DiaChiGiaoHang' => $diaChiGiaoHang,
                'GhiChu' => $ghiChu,
                'SoDienThoai' =>$soDienThoai,
                'NguoiNhan' =>$nguoinhan
            ]);

            foreach ($items as $item) {
                ChiTietDonHang::create([
                    'DonHangId' => $donHang->DonHangId,
                    'SanPhamId' => $item['SanPhamId'],
                    'SoLuong' => $item['SoLuong'],
                    'Gia' => $item['Gia'],
                ]);
            }
            foreach ($sanPhamList as $sanPhamData) {
                $sanPhamId = $sanPhamData['SanPhamId'];
            
                $gioHangIds = GioHang::where('NguoiDungId', $nguoiDungId)
                    ->pluck('GioHangId'); 
            
                ChiTietGioHang::whereIn('GioHangId', $gioHangIds) 
                    ->where('SanPhamId', $sanPhamId)
                    ->delete();
            }
            

            foreach ($items as $item) {
                $sanPham = SanPham::find($item['SanPhamId']);
                $sanPham->SoLuongTon -= $item['SoLuong'];
                $sanPham->save();
            }

            return response()->json([
                'message' => 'Đặt hàng thành công.',
                'order' => [
                    'order_id' => $donHang->DonHangId,
                    'total_price' => $totalPrice,
                    'items' => $items,
                ],
            ]);

        } catch (\Exception $e) {
            
            return response()->json([
                'message' => 'Đã có lỗi xảy ra.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    public function getOrdersByUser($nguoiDungId)
    {
        try {
            $donHangs = DonHang::where('NguoiDungId', $nguoiDungId)
                ->with(['chiTietDonHangs', 'chiTietDonHangs.sanPham'])  
                ->get();

            if ($donHangs->isEmpty()) {
                return response()->json([
                    'message' => 'Không có đơn hàng nào của người dùng này.',
                ], 201);
            }

            return response()->json([
                'orders' => $donHangs,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Đã có lỗi xảy ra.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    public function cancelOrder($donHangId)
    {
        try {
            $donHang = DonHang::find($donHangId);

            if (!$donHang) {
                return response()->json([
                    'message' => 'Đơn hàng không tồn tại.',
                ], 404);
            }

            $createdAt = Carbon::parse($donHang->ngaydathang);
            $currentTime = Carbon::now(); 

            $diffInHours = $createdAt->diffInHours($currentTime);

            if ($diffInHours > 2) {
                return response()->json([
                    'message' => 'Bạn chỉ được hủy đơn hàng trong vòng 2 tiếng kể từ khi đặt hàng.',
                ], 400);
            }

            $chiTietDonHang = ChiTietDonHang::where('DonHangId', $donHangId)->get();

            foreach ($chiTietDonHang as $item) {
                $sanPham = SanPham::find($item->SanPhamId);
                if ($sanPham) {
                    $sanPham->SoLuongTon += $item->SoLuong;
                    $sanPham->save();
                }
            }

            ChiTietDonHang::where('DonHangId', $donHangId)->delete();

            $donHang->delete(); 

            return response()->json([
                'message' => 'Đơn hàng đã được hủy thành công.',
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Đã có lỗi xảy ra.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function updateCartItemQuantity(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'NguoiDungId' => 'required|integer|exists:GioHang,NguoiDungId',
                'SanPhamId' => 'required|integer|exists:SanPham,SanPhamId',
                'SoLuong' => 'required|integer|min:1',
            ]);

            $nguoiDungId = $validatedData['NguoiDungId'];
            $sanPhamId = $validatedData['SanPhamId'];
            $soLuongMoi = $validatedData['SoLuong'];

            $gioHang = GioHang::where('NguoiDungId', $nguoiDungId)->first();
            if (!$gioHang) {
                return response()->json([
                    'message' => 'Giỏ hàng không tồn tại.',
                ], 404);
            }

            $cartItem = ChiTietGioHang::where('GioHangId', $gioHang->GioHangId)
                ->where('SanPhamId', $sanPhamId)
                ->first();

            if (!$cartItem) {
                return response()->json([
                    'message' => 'Sản phẩm không tồn tại trong giỏ hàng.',
                ], 404);
            }

            $sanPham = SanPham::find($sanPhamId);
            if ($sanPham->SoLuongTon + $cartItem->SoLuong < $soLuongMoi) {
                return response()->json([
                    'message' => 'Số lượng sản phẩm trong kho không đủ.',
                ], 400);
            }

            $sanPham->SoLuongTon += $cartItem->SoLuong - $soLuongMoi;
            $sanPham->save();

            $cartItem->SoLuong = $soLuongMoi;
            $cartItem->Gia = $soLuongMoi * $sanPham->Gia;
            $cartItem->save();

            $gioHang->TongTien = ChiTietGioHang::where('GioHangId', $gioHang->GioHangId)->sum('Gia');
            $gioHang->save();

            return response()->json([
                'message' => 'Cập nhật số lượng sản phẩm thành công.',
                'cart' => $gioHang,
                'updated_item' => $cartItem,
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Đã có lỗi xảy ra.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    public function getCartItemCount(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'NguoiDungId' => 'required|integer|exists:GioHang,NguoiDungId',
            ]);
    
            $nguoiDungId = $validatedData['NguoiDungId'];
    
            $gioHang = GioHang::where('NguoiDungId', $nguoiDungId)->first();
    
            if (!$gioHang) {
                return response()->json([
                    'message' => 'Giỏ hàng của bạn hiện đang trống.',
                    'item_count' => 0,
                ]);
            }
    
            $itemCount = ChiTietGioHang::where('GioHangId', $gioHang->GioHangId)->sum('SoLuong');
    
            return response()->json([
                'message' => 'Số lượng sản phẩm trong giỏ hàng được lấy thành công.',
                'item_count' => $itemCount,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Đã xảy ra lỗi khi lấy số lượng sản phẩm trong giỏ hàng.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    
}
