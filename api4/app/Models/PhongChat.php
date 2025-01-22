<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PhongChat extends Model
{
    use HasFactory;
    protected $table = 'phongchat';
    protected $primaryKey = 'PhongChatId';
    protected $keyType = 'int';
    public $timestamps = false;

    public function nguoiDung()
    {
        return $this->belongsTo(NguoiDung::class, 'NguoiDungId');
    }

    public function tinNhans()
    {
        return $this->hasMany(TinNhan::class, 'PhongChatId');
    }
}
