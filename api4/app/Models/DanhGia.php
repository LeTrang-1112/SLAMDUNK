<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DanhGia extends Model
{
    use HasFactory;

    protected $table = 'DanhGia';
    protected $primaryKey = 'DanhGiaId';
    public $timestamps = false;

    protected $fillable = [
        'DonHangId',
        'CTDHId',
        'NoiDung',
        'Sao',
        'NgayDanhGia',
    ];

    public function donHang()
    {
        return $this->belongsTo(DonHang::class, 'DonHangId');
    }

    public function chiTietDonHang()
    {
        return $this->belongsTo(ChiTietDonHang::class, 'CTDHId');
    }
   

}
