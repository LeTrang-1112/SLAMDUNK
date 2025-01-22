<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TinNhan extends Model
{
    use HasFactory;
    protected $table = 'tinnhan';
    protected $primaryKey = 'TinNhanId';
    protected $keyType = 'int';
    public $timestamps = false;

    public function phongChat()
    {
        return $this->belongsTo(PhongChat::class, 'PhongChatId');
    }
}
