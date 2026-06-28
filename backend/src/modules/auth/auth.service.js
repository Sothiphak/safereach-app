import { Injectable, Dependencies } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { UsersService } from '../users/users.service';

@Injectable()
@Dependencies(UsersService, JwtService)
export class AuthService {
  constructor(usersService, jwtService) {
    this.usersService = usersService;
    this.jwtService = jwtService;
  }

  async register(payload) {
    const user = await this.usersService.create(payload);
    return this.buildAuthResponse(user);
  }

  async login(payload) {
    const user = await this.usersService.validateUser(
      payload.email,
      payload.password,
    );
    return this.buildAuthResponse(user);
  }

  buildAuthResponse(user) {
    const tokenPayload = { sub: user.id, email: user.email };
    const accessToken = this.jwtService.sign(tokenPayload);
    return {
      accessToken,
      user: this.usersService.toSafeUser(user),
    };
  }
}
