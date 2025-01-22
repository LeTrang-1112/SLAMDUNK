<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ChiTietGioHang extends Model
{
    use HasFactory;
    protected $table = 'chitietgiohang';
    protected $primaryKey = 'CTGHId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'GioHangId',
        'SanPhamId',
        'SoLuong',
        'Gia',
    ];
    public function gioHang()
    {
        return $this->belongsTo(GioHang::class, 'GioHangId');
    }

    public function sanPham()
    {
        return $this->belongsTo(SanPham::class, 'SanPhamId');
    }
}
