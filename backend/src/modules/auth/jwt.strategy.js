import {
  Injectable,
  UnauthorizedException,
  Dependencies,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

import { UsersService } from '../users/users.service';

@Injectable()
@Dependencies(ConfigService, UsersService)
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(configService, usersService) {
    const jwtSecret = configService.get('JWT_SECRET');
    if (!jwtSecret && configService.get('NODE_ENV') === 'production') {
      throw new Error('JWT_SECRET is required in production.');
    }

    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtSecret || 'safereach-dev-secret',
    });
    this.usersService = usersService;
  }

  async validate(payload) {
    const user = await this.usersService.findById(payload.sub);
    if (!user) {
      throw new UnauthorizedException();
    }
    return this.usersService.toSafeUser(user);
  }
}
