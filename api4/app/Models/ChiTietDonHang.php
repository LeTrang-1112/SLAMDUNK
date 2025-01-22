<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ChiTietDonHang extends Model
{
    use HasFactory;
    protected $table = 'chitietdonhang';
    protected $primaryKey = 'CTDHId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'DonHangId',
        'SanPhamId',
        'SoLuong',
        'Gia',
    ];
    public function donHang()
    {
        return $this->belongsTo(DonHang::class, 'DonHangId');
    }
    public function sanPham()
    {
        return $this->belongsTo(SanPham::class, 'SanPhamId');
    }
}
